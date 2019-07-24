class MessageController < ApplicationController
    
    require "line/bot"
    require "json"
    require "aws-sdk-s3"
    require "date"
    
    protect_from_forgery :except => [:callback]
    
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_id = ENV["LINE_CHANNEL_ID"]
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
    
    def callback
        body = request.body.read
        
        # 署名検証
        hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, ENV["LINE_CHANNEL_SECRET"], body)
        signature = Base64.strict_encode64(hash)
        puts signature
        req_signature = request.env["HTTP_X_LINE_SIGNATURE"]
        unless signature.eql?(req_signature)
            render :status => 400 , :json => { error: "invalid_request" , error_description: "some parameters missed or invalid" }
            return
        end
        
        # 受信メッセージ内容を取得
        events = client.parse_events_from(body)
        events.each do |event|
            
            # 送信元ユーザーIDを取得
            userId = event["source"]["userId"]
            # ユーザーのステータスを確認
            sendUser = User.find_by_line_id(userId)
            
            # 返信用メッセージ配列の初期化
            messages = []
            
            # Event Typeによりアクションを決定
            case event
            
            # follow Event
            when Line::Bot::Event::Follow
                
                if sendUser.nil?
                    # User regist
                    sendUser = User.new
                    sendUser.name = "New User"
                    sendUser.line_id = userId
                    sendUser.status = "00"
                    
                    # follow message send
                    message = {
                        type: "text",
                        text: "フォローありがとうでし！\n" +
                            "ブキの名前を言ってくれればブキの情報を教えるでし。\n" +
                            "ランダムにブキを選んで欲しいときはメニューから「ブキルーレット」を選ぶでし。"
                    }
                    messages.push(message)
                    
                else
                    sendUser.del_flg = false
                    # follow message send
                    message = {
                        type: "text",
                        text: "いらっしゃいでし！ブキの事ならなんでも聞くでし！"
                    }
                    messages.push(message)
                end
                
                unless sendUser.save
                    # error handle
                end
                
                client.reply_message(event["replyToken"], message)
            
            # Unfollow Event
            when Line::Bot::Event::Unfollow
                
                sendUser.del_flg = true
                unless sendUser.save
                    # error handle
                end
                
            # Messgae Event
            when Line::Bot::Event::Message
            
                # Message regist
                receiptMessage = Message.new
                receiptMessage.message_id = event.message["id"]
                receiptMessage.message_type = event.message["type"]
            
                case event.type
                # Text Message
                when Line::Bot::Event::MessageType::Text
                    
                    # Webhook接続確認でない場合
                    unless event["replyToken"] == "00000000000000000000000000000000"
                        
                        case sendUser.status
                        when "00" # 通常
                        
                            case event.message["text"]
                            when "#weapon_roulette"
                                

                                
                                selectted_weapon = nil
                                main_hash = nil
                                File.open("public/main.json") do |j|
                                    main_hash = JSON.load(j)
                                    selectted_weapon = main_hash[main_hash.keys[rand(main_hash.length)]]
                                end
                                
                                # ブキ画像のURL設定 
                                img_url = "https://" + request.host_with_port + "/main_weapon_img/" + selectted_weapon["key"] + '.png'
                                message = {
                                    type: "image",
                                    originalContentUrl: img_url ,
                                    previewImageUrl: img_url
                                }
                                messages.push(message)
                                
                                # ブキ名の設定
                                message = {
                                    type: "text",
                                    text: selectted_weapon["localization"]["ja"] + "を使うでし！"
                                }
                                messages.push(message)
                                
                                # Pending
                                # sendUser = User.find_by_line_id(userId)
                                # sendUser.status = "10" #ブキルーレット開始
                                
                                
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
                                    
                                    message = {
                                        type: "text",
                                        text: message_text
                                    }
                                    messages.push(message)
                                    
                                    # ブキチの説明をメッセージで送る
                                    # Pending
                                    
                                else
                                    # 検索結果が存在しない場合
                                    message = {
                                        type: "text",
                                        text: "ブキのこと以外は興味ないでし"
                                    }
                                    messages.push(message)
                                end
                            end
                            
                        when "10" # ブキルーレット開始
                            
                            # Pending
                            # 連続でブキを選択する機能とする
                            # やめる場合はステータスを"00"に戻す
                        
                        end
                        
                    end
                    # 返信
                    client.reply_message(event["replyToken"], messages)
                    
                    # メッセージ履歴の登録
                    receiptMessage.request = event.message["text"]
                    receiptMessage.response = messages
                    unless receiptMessage.save
                        # error handle
                    end
                    
                when Line::Bot::Event::MessageType::Sticker
                    
                    receiptMessage.request = 
                        JSON.parse('{ "packageId":' + event.message["packageId"] + "," + '"sickerId":' + event.message["stickerId"] + "}")
                    
                    message = {
                        type: "sticker",
                        packageId: "11537",
                        stickerId: "52002744"
                    }
                    
                    # 返信
                    client.reply_message(event["replyToken"], message)
                    
                    # メッセージ内容を登録
                    receiptMessage.response = message
                    unless receiptMessage.save
                        # error handle
                    end
                    
                # その他のメッセージ
                else
                    
                    message = {
                        type: "text",
                        text: "興味ないでし"
                    }
                    
                    # 返信
                    client.reply_message(event["replyToken"], message)
                    
                    # メッセージ内容を登録
                    receiptMessage.response = message
                    unless receiptMessage.save
                        # error handle
                    end
                    
                end
            end
        end
        
        render :status => 200 , :json => { }
        return
    end
    
end
