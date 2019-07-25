# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ApplicationRecord.transaction do
    
    #---------------------------
    # User
    #---------------------------
    users = User.create([
        # 通常ユーザー
        { :name => "Shirokuma" , :line_id => "U01c7d4ac06b42fb8c59c2a1256604aaa" , :status => User::STATUS[:normal] , :talk_status => User::TALK_STATUS[:normal] , :del_flg => false},
        # 削除済ユーザー
        { :name => "Inu" , :line_id => "U01c7d4ac06b42fb8c59c2a1256604bbb" , :status => User::STATUS[:normal] , :talk_status => User::TALK_STATUS[:normal] ,  :del_flg => true},
        # チャット機能使用中ユーザー１
        { :name => "Geso" , :line_id => "U01c7d4ac06b42fb8c59c2a1256604aaa" , :status => User::STATUS[:normal] , :talk_status => User::TALK_STATUS[:fest_vote] ,  :del_flg => false},
        # チャット機能使用中ユーザー２
        { :name => "Lion" , :line_id => "U01c7d4ac06b42fb8c59c2a1256604aaa" , :status => User::STATUS[:normal] , :talk_status => User::TALK_STATUS[:fest_record] ,  :del_flg => false},
        # チャット機能使用中ユーザー３
        { :name => "Panda" , :line_id => "U01c7d4ac06b42fb8c59c2a1256604aaa" , :status => User::STATUS[:normal] , :talk_status => User::TALK_STATUS[:normal] ,  :del_flg => false},
        # チャット機能使用中ユーザー４
        { :name => "Tsubame" , :line_id => "U01c7d4ac06b42fb8c59c2a1256604aaa" , :status => User::STATUS[:normal] , :talk_status => User::TALK_STATUS[:normal] ,  :del_flg => false},
    ])
    
    
    #---------------------------
    # Message
    #---------------------------
    messages = Message.create([
        {:message_id => "00000000000001", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[0].id },
        {:message_id => "00000000000002", :message_type => "text", :request => '"{\"packageId\":"00001",\"stickerId\":\"00000001\"}"', :response => '"{\"type\":\"sticker\",\"packageId\":\"11537\",\"stickerId\":\"52002744\"}"' , :user_id => users[0].id },
        {:message_id => "00000000000003", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[1].id },
        {:message_id => "00000000000004", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[1].id },
        {:message_id => "00000000000005", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[2].id },
        {:message_id => "00000000000006", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[2].id },
        {:message_id => "00000000000007", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[3].id },
        {:message_id => "00000000000008", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[3].id },
        {:message_id => "00000000000009", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[4].id },
        {:message_id => "00000000000010", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[4].id },
        {:message_id => "00000000000010", :message_type => "text", :request => "Hello", :response => '"{\"type\":\"text\",\"text\":\"Good evening\"}"' , :user_id => users[4].id }
    ])
    
    
    
    #---------------------------
    # Fest
    #---------------------------
    
    fests = Fest.create([
        {:fest_name => "きのこ・たけのこフェス", :fest_status => Fest::FEST_STATUS[:close] , :selection_a => "きのこ" , :selection_b => "たけのこ" , :fest_result => "a"},
        {:fest_name => "きつね・たぬきフェス", :fest_status => Fest::FEST_STATUS[:open] , :selection_a => "きつね" , :selection_b => "たぬき" , :fest_result => nil},
        {:fest_name => "しろくま・パンダフェス", :fest_status => Fest::FEST_STATUS[:not_open] , :selection_a => "しろくま" , :selection_b => "パンダ" , :fest_result => nil},
    ])
    
    fest_votes = FestVote.create([
        {:fest_id => fests[0].id , :user_id => users[0].id , :selection => "a" , :game_count => 10 , :win_count => 6 , :win_rate => 60.00},
        {:fest_id => fests[0].id , :user_id => users[1].id , :selection => "a" , :game_count => 10 , :win_count => 6 , :win_rate => 60.00},
        {:fest_id => fests[0].id , :user_id => users[2].id , :selection => "a" , :game_count => 10 , :win_count => 6 , :win_rate => 60.00},
        {:fest_id => fests[0].id , :user_id => users[3].id , :selection => "b" , :game_count => 10 , :win_count => 4 , :win_rate => 40.00},
        {:fest_id => fests[0].id , :user_id => users[4].id , :selection => "b" , :game_count => 10 , :win_count => 4 , :win_rate => 40.00},
        {:fest_id => fests[0].id , :user_id => users[5].id , :selection => "b" , :game_count => 10 , :win_count => 4 , :win_rate => 40.00},
        {:fest_id => fests[1].id , :user_id => users[0].id , :selection => "a" , :game_count => 10 , :win_count => 3 , :win_rate => 30.00},
        {:fest_id => fests[1].id , :user_id => users[1].id , :selection => "a" , :game_count => 10 , :win_count => 3 , :win_rate => 30.00},
        {:fest_id => fests[1].id , :user_id => users[2].id , :selection => "a" , :game_count => 10 , :win_count => 3 , :win_rate => 30.00},
        {:fest_id => fests[1].id , :user_id => users[3].id , :selection => "b" , :game_count => 10 , :win_count => 7 , :win_rate => 70.00},
        {:fest_id => fests[1].id , :user_id => users[4].id , :selection => "b" , :game_count => 10 , :win_count => 7 , :win_rate => 70.00},
        {:fest_id => fests[1].id , :user_id => users[5].id , :selection => "b" , :game_count => 10 , :win_count => 7 , :win_rate => 70.00}
    ])

end