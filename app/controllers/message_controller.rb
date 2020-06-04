class MessageController < ApplicationController
    
    # 使用Gem
    require "line/bot"
    require "json"
    require "aws-sdk-s3"
    require "date"
    
    # csrf対策のトークンを含めない
    protect_from_forgery :except => [:callback]
    
    # client
    # Line clientの定義
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_id = ENV["LINE_CHANNEL_ID"]
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
    
    # callback
    # メッセージを受信して実行される処理
    def callback
        
        # 署名検証
        unless signature_valid?
            render :status => 400 , :json => { error: "invalid_request" , error_description: "some parameters missed or invalid" }
            return
        end
        
        # 受信メッセージ内容を取得
        events = client.parse_events_from(request.body.read)
        events.each do |event|
            
            # ユーザーの取得
            userId = event["source"]["userId"]
            @sendUser = User.find_by_line_id(userId)
            
            # Event Typeによりアクションを決定
            case event
            # follow Event
            when Line::Bot::Event::Follow
                follow_event(event)
            # Unfollow Event
            when Line::Bot::Event::Unfollow
                unfollow_event
            # Messgae Event
            when Line::Bot::Event::Message
                message_event(event)
            # Postback Event
            when Line::Bot::Event::Postback
                postback_event(event)
            end
        end
        
        render :status => 200 , :json => { }
        return
    end
    
    # 署名検証
    # request.bodyのダイジェストとrequest.header[X-Line-Signature]を比較して結果を返す
    def signature_valid?
        hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, ENV["LINE_CHANNEL_SECRET"], request.body.read)
        signature = Base64.strict_encode64(hash)
        puts signature if Rails.env == "test"
        return signature.eql?(request.env["HTTP_X_LINE_SIGNATURE"])
    end
    
    # フォローイベント
    def follow_event(event)
        
        # 返信用メッセージ配列（最大５件）
        messages = []
        
        if @sendUser.nil?
            # 新規フォローの場合
            
            @sendUser = User.new
            @sendUser.line_id = event["source"]["userId"]
            @sendUser.status = User::STATUS[:normal]
            @sendUser.talk_status = User::TALK_STATUS[:normal]
            
            # ユーザープロフィールの取得
            response = client.get_profile(event["source"]["userId"])
            case response
            when Net::HTTPSuccess then
              @sendUser.name = JSON.parse(response.body)["displayName"]
            else
              puts "#{response.code} #{response.body}" if Rails.env == "test"
              @sendUser.name = "New User"
            end

            # Message set
            messages.push(Message::RESPONSE_FOLLOW_MESSAGE)
            
        else
            # ブロック解除の場合
            
            @sendUser.status = User::STATUS[:normal]
            @sendUser.talk_status = User::TALK_STATUS[:normal]
            @sendUser.del_flg = false
            
            # Message set
            messages.push(Message::RESPONSE_BLOCK_CANCEL_MESSAGE)
            
        end
        
        # ユーザーの登録/更新
        @sendUser.save!
        
        # 返信
        client.reply_message(event["replyToken"], messages)
    end
    
    # フォロー解除イベント
    def unfollow_event
        
        @sendUser.del_flg = true
        
        # ユーザーの登録/更新
        unless @sendUser.save
            # error handle
        end 
    end
    
    # メッセージイベント
    def message_event(event)
       
        messages = []
        
        receiptMessage = Message.new
        receiptMessage.message_id = event.message["id"]
        receiptMessage.message_type = event.message["type"]
        
        case event.type
        # Text Message
        when Line::Bot::Event::MessageType::Text
            
            # Webhook接続確認の場合は処理を抜ける
            if event["replyToken"] == "00000000000000000000000000000000"
               return 
            end    
            
            # ユーザーがNullの場合、登録する
            if @sendUser.nil?
                @sendUser = User.new
                @sendUser.line_id = event["source"]["userId"]
                @sendUser.status = User::STATUS[:normal]
                @sendUser.talk_status = User::TALK_STATUS[:normal]
                # ユーザープロフィールの取得
                response = client.get_profile(event["source"]["userId"])
                case response
                when Net::HTTPSuccess then
                  @sendUser.name = JSON.parse(response.body)["displayName"]
                else
                  puts "#{response.code} #{response.body}" if Rails.env == "test"
                  @sendUser.name = "New User"
                end
                @sendUser.save!
            end
            
            # トークステータスによる分岐
            case @sendUser.talk_status
            when User::TALK_STATUS[:normal] # 通常
            
                # キーワードによる分岐
                case event.message["text"]
                when "ブキを選んで！"
                    
                    # ブキランダム取得
                    selectted_weapon = get_random_weapon
                    
                    # ブキ画像のURL設定 
                    img_url = "https://" + request.host_with_port + "/main_weapon_img/" + selectted_weapon["key"] + '.png'
                    
                    actions =[]
                    defaultAction = set_message_action_object("このブキについて教えて！",selectted_weapon["localization"]["ja"])
                    actions.push(defaultAction)
                    
                    messages.push(
                        set_button_template(
                            selectted_weapon["localization"]["ja"],
                            img_url,
                            selectted_weapon["localization"]["ja"],
                            "これを使うでし！",
                            defaultAction,
                            actions
                        )
                    )
                
                when "フェスに投票する！"
                    
                    # 開催中のフェス情報を取得
                    @fests = Fest.where(fest_status: "open").order(:updated_at ,"DESC").limit(10)
                    if @fests.exists?
                        if @sendUser.status == User::STATUS[:fest]
                        
                            # フェスに未投票の場合
                            @sendUser.talk_status = User::TALK_STATUS[:fest_vote]
                            @sendUser.save!
                                    
                            # 開催中のフェスのリストを投げる
                            # ボタンメッセージを投げる
                            actions = []
                            defaultAction = set_message_action_object(
                                "やめる",
                                "やめる")
                            @fests.each do |fest|
                                actions.push(set_postback_action_object(
                                    @fest.selection_a,
                                    "step=1&fest_id="+fest.id.to_s,
                                    festt.fest_name)
                                )
                            end
                            actions.push(set_postback_action_object(
                                @fest.selection_b,
                                "step=1&fest_id="+@fest.id.to_s+"&selection=b",
                                @fest.selection_b + "に投票する！")
                            )
                            # TODO：その他の選択肢（Webから投票/続きの検索）を実装したらボタン追加
                                
                        else
                            # フェス参加中の場合
                            # ユーザーのチームを返す
                            fest_vote = FestVote.where("(fest_id = ?) OR (user_id = ?)", @fest.id,@sendUser.id).limit(1)[0]
                            if fest_vote.selection == "a" 
                                user_selection = @fest.selection_a 
                            else 
                                user_selection = @fest.selection_b
                            end
                            messages.push({
                                type: "text",
                                text: "すでに投票済みでし！\n君は「" + user_selection + "」チームでし！"
                            })
                            
                        end
                    else
                        messages.push({
                           type: "text",
                           text: "現在開催中のフェスはなかったでし。"
                        })
                    end
                    
                when "戦績を記録する！"

                    if @sendUser.status == User::STATUS[:fest]
                        # 戦績の記録ステータスに変更する
                        @sendUser.talk_status = User::TALK_STATUS[:fest_record]
                        @sendUser.save!
                        
                        # フェス投票データを取得
                        fest_vote = FestVote.includes(:fest).where(fests: {fest_status: Fest::FEST_STATUS[:open]}, fest_votes: {user_id: @sendUser.id}).first
                        
                        actions = []
                        actions.push(set_postback_action_object("Win!","step=1&fest_vote_id="+fest_vote.id.to_s+"&result=1","Win!"))
                        actions.push(set_postback_action_object("Lose...","step=1&fest_vote_id="+fest_vote.id.to_s+"&result=2","Lose..."))
                        messages.push(
                            set_confirm_template(
                                "試合結果の記録",
                                "試合の結果はどうだったでしか？",
                                actions
                            )
                        )
                        
                    else
                        messages.push({    
                            type: "text",
                            text: "まずはフェスに投票するでし！"
                        })
                    end
                
                else
                    
                    # メッセージの内容でブキを検索
                    query_weapon = MainWeapon.find_by_name(event.message["text"])
                
                    unless query_weapon.nil?
                        # 検索結果が存在する場合
                            
                        # メインJSONの読み込み
                        weapon_data = nil
                        sub_data = nil
                        special_data = nil
                        
                        File.open("public/main.json") do |j|
                            main_hash = JSON.load(j)
                            weapon_data = main_hash[query_weapon.json_key]
                        end
                        
                        File.open("public/sub.json") do |j|
                            sub_hash = JSON.load(j)
                            sub_data = sub_hash[weapon_data["sub_key"]]
                        end
                        
                        File.open("public/special.json") do |j|
                            special_hash = JSON.load(j)
                            special_data = special_hash[weapon_data["special_key"]]
                        end  
                        
                        message_text = weapon_data["localization"]["ja"] + "は、\n" +
                            "サブウェポンが" + sub_data["localization"]["ja"] + "で、\n" +
                            "スペシャルは" + special_data["localization"]["ja"] + "でし。\n" +
                            "スペシャルに必要なポイントは" + weapon_data["special_points"].to_s + "でし。"
                        
                        messages.push({
                            type: "text",
                            text: message_text
                        })
                        
                    else
                        # 検索結果が存在しない場合
                        
                        joke = Joke.find_by_message(event.message["text"]) || { :message => "other" , :response => "ブキのこと以外は興味ないでし。" }
                        
                        messages.push({
                            type: "text",
                            text: joke[:response]
                        })
                        
                    end
                end
            
            # トークステータスが通常以外の時
            else
                messages.push({
                    type: "text",
                    text: "選択を中断したでし！"
                })
                
                @sendUser.talk_status = User::TALK_STATUS[:normal]
                @sendUser.save!
                
            end
            
            receiptMessage.request = event.message["text"]
            
        when Line::Bot::Event::MessageType::Sticker
            
            messages.push({
                type: "sticker",
                packageId: "11537",
                stickerId: "52002744"
            })
            
            receiptMessage.request = 
                JSON.parse('{ "packageId":' + event.message["packageId"] + "," + '"sickerId":' + event.message["stickerId"] + "}")
            
        # その他のメッセージ
        else
            
            messages.push({
                type: "text",
                text: "興味ないでし。"
            })
            
        end
        
        # 返信
        reply_response = client.reply_message(event["replyToken"], messages)
        
        # メッセージ内容を登録
        receiptMessage.response = messages
        receiptMessage.user_id = @sendUser.id
        receiptMessage.reply_response = JSON.parse(reply_response.body)
        unless receiptMessage.save
            # error handle
        end
    end
    
    # Postback イベント
    def postback_event(event)
        
        messages = []
        
        receiptMessage = Message.new
        receiptMessage.message_id = event["replyToken"]
        receiptMessage.message_type = event["type"] 
        receiptMessage.request = event["postback"]
        receiptMessage.user_id = @sendUser.id
        
        postback_data = event["postback"]["data"].split("&")
        
        # ユーザーのトークステータスによる分岐
        case @sendUser.talk_status
        when User::TALK_STATUS[:fest_vote] # フェス投票
            step = postback_data[0].delete("step=")
            
            # PostbackメッセージのStepによる分岐
            case step
            
            # 投票先の選択（再選択）
            when "0"
                fest_id = postback_data[1].delete!("fest_id=")
                fest = Fest.find(fest_id.to_i)
                
                # ボタンメッセージを投げる
                actions = []
                defaultAction = set_message_action_object(
                    "やめる",
                    "やめる")
                actions.push(set_postback_action_object(
                    fest.selection_a,
                    "step=1&fest_id="+postback_data[1]+"&selection=a",
                    fest.selection_a + "に投票する！")
                )
                actions.push(set_postback_action_object(
                    fest.selection_b,
                    "step=1&fest_id="+postback_data[1]+"&selection=b",
                    fest.selection_b + "に投票する！")
                )
                messages.push(
                    set_button_template(
                        fest.fest_name + "投票",
                        fest.fest_image,
                        fest.fest_name,
                        "あなたは「"+fest.selection_a+"」、「"+fest.selection_b+"」どっち？",
                        defaultAction,
                        actions
                    )
                )
            when "1"
                # 投票内容の取得
                fest_id = postback_data[1].delete!("fest_id=")
                selection = postback_data[2].delete!("selection=")
                
                fest = Fest.find(fest_id.to_i)
                if selection == "a"
                    selection_name = fest.selection_a
                else
                    selection_name = fest.selection_b
                end
                
                # 確認メッセージを投げる
                actions = []
                actions.push(set_postback_action_object("オッケー!","step=2&fest_id="+postback_data[1]+"&selection="+postback_data[2],"オッケー!"))
                actions.push(set_postback_action_object("ちがうよ！","step=0&fest_id="+postback_data[1],"ちがうよ！"))
                messages.push(
                    set_confirm_template(
                        "フェス投票の確認",
                        "投票は「" + selection_name + "」で間違いないでしか？",
                        actions
                    )
                )
            when "2"
                # 投票結果を登録する
                FestVote.create!({
                    :fest_id => postback_data[1].delete!("fest_id=").to_i,
                    :user_id => @sendUser.id,
                    :selection => postback_data[2].delete!("selection=")
                })
                
                messages.push({
                    type: "text",
                    text: "投票したでし！"
                })
                
                @sendUser.status = User::STATUS[:fest]
                @sendUser.talk_status = User::TALK_STATUS[:normal]
                @sendUser.save!

            end
            
        when User::TALK_STATUS[:fest_record] # フェス戦績の記録
            
            step = postback_data[0].delete!("step=")
            
            # PostbackメッセージのStepによる分岐
            case step
            
            # 試合結果の再選択
            when "0"

                actions = []
                actions.push(set_postback_action_object("Win!","step=1&"+postback_data[1]+"&result=1","Win!"))
                actions.push(set_postback_action_object("Lose...","step=1&"+postback_data[1]+"&result=2","Lose..."))
                messages.push(
                    set_confirm_template(
                        "試合結果の記録",
                        "試合の結果はどうだったでしか？",
                        actions
                    )
                )
                
            # 登録内容の確認
            when "1"

                result = postback_data[2].delete!("result=")
                selection = nil
                if result == "1"
                    selection = "Win"
                else
                    selection = "Lose"
                end
                # 確認メッセージを投げる
                actions = []
                actions.push(set_postback_action_object("オッケー！","step=2&"+postback_data[1]+"&result="+postback_data[2],"オッケー！"))
                actions.push(set_postback_action_object("ちがうよ！","step=0&"+postback_data[1],"ちがうよ！"))
                messages.push(
                    set_confirm_template(
                        "試合結果の確認",
                        "試合結果は「" + selection + "」で間違いないでしか？",
                        actions
                    )
                )
            
            # 試合結果の登録
            when "2"
                # 試合結果を登録する
                result = postback_data[2].delete!("result=")
                fest_vote = FestVote.find(postback_data[1].delete!("fest_vote_id=").to_i)
                fest_vote.game_count = fest_vote.game_count + 1
                if result == "1"
                    fest_vote.win_count = fest_vote.win_count + 1
                end
                if fest_vote.win_count == 0
                    fest_vote.win_rate = 0
                else
                    fest_vote.win_rate = (fest_vote.win_count.to_f / fest_vote.game_count.to_f * 100).round(2)
                end
                fest_vote.save!
                
                messages.push({
                    type: "text",
                    text: "登録したでし！"
                })
                
                @sendUser.talk_status = User::TALK_STATUS[:normal]
                @sendUser.save!
                
            end
            
            
        end
        
        # 返信
        reply_response = client.reply_message(event["replyToken"], messages)
        
        # メッセージ内容を登録
        receiptMessage.response = messages
        receiptMessage.reply_response = JSON.parse(reply_response.body)
        unless receiptMessage.save
            # error handle
        end
        
    end
    
    # ブキランダム選択
    def get_random_weapon
        selectted_weapon = nil
        File.open("public/main.json") do |j|
            main_hash = JSON.load(j)
            selectted_weapon = main_hash[main_hash.keys[rand(main_hash.length)]]
        end
        return selectted_weapon
    end
    
    # ボタンテンプレート
    def set_button_template(altText,img_url,title,text,defaultAction,actions)
        return {
          type: "template",
          altText: altText,
          template: {
              type: "buttons",
              thumbnailImageUrl: img_url,
              imageAspectRatio: "rectangle",
              imageSize: "cover",
              imageBackgroundColor: "#FFFFFF",
              title: title,
              text: text,
              defaultAction: defaultAction,
              actions: actions
          }
        }
    end
    
    # 確認テンプレート
    def set_confirm_template(altText,text,actions)
        return {
          type: "template",
          altText: altText,
          template: {
              type: "confirm",
              text: text,
              actions: actions
          }
        } 
    end
    
    # メッセージアクションオブジェクト
    def set_message_action_object(label,text)
        return {
            type: "message",
            label: label,
            text: text
        }
    end
    
    # ポストバックアクションオブジェクト
    def set_postback_action_object(label,data,displayText)
        return {  
            type: "postback",
            label: label,
            data: data,
            displayText: displayText
        } 
        
    end
end
