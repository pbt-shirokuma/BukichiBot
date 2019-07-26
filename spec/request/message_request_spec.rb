require 'rails_helper'

RSpec.describe MessageController, type: :request do
  
  # describe: テスト対象
  describe 'POST /callback' do
    
    # context: テストする状況、条件
    context 'message receive' do

      # it: テスト内容を is ~ で記載
      it 'is validation illegal signature' do
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ123="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "bad_signature.json" )) , :headers => headers
        
        # HTTPステータスが400であること
        expect(response.status).to eq(400)
      end
       
      it 'is received weapon name message' do
        @user = create(:user) 
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "lJYCsaxP6KxCMH9LJT6vU/emb+X1kpgKKVt8L03MYeU="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "weapon_name_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is received weapon roulette message' do
        @user = create(:user) 
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "VIa/ybpsGXgg0boWL5Ix0/la3x/oOXtfSYnBq4h/CQQ="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "weapon_roulette_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is received sticker message' do
        @user = create(:user) 
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "vrucXT2fn176VYTE+cIkvVyCZmx6zZkbDle7KFUXCOo="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "sticker_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
        
      it 'is received image/video message' do
        @user = create(:user) 
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "mULImoFBGN19sfDmPmTyByEybECxvbirS6nCjzdNW5I="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "image_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is fest vote message' do
        @user = create(:user) 
        @fest = create(:fest , fest_status: "10")
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "Zfo8Gg/6831cpCdjtZHT4ay6i5dht0hmCjd6Q+B6yR4="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_vote_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      it 'is fest vote message but open fest none' do
        @user = create(:user) 
        @fest = create(:fest)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "Zfo8Gg/6831cpCdjtZHT4ay6i5dht0hmCjd6Q+B6yR4="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_vote_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is fest record message' do
        @user = create(:user , status: "10") 
        @fest = create(:fest , fest_status: "10")
        @fest_vote = create(:fest_vote)

        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "vwJbQteVZjz1AsFWBqWbIvFfG8v9H9M0fAKkstS/Bbo="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_record_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      it 'is fest record message but user dont vote' do
        @user = create(:user , status: "00") 
        @fest = create(:fest , fest_status: "10")
        @fest_vote = create(:fest_vote)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "vwJbQteVZjz1AsFWBqWbIvFfG8v9H9M0fAKkstS/Bbo="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_record_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
    end
    
    context 'follow event' do
      it 'is new follower add' do
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "dik+l1ChiePTF7EDKwRMX5SLPJ6P6eo6BHISRico6mE="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "follow_event.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end

      it 'is block cancel' do
        @user = create(:user , del_flg: true) 
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "dik+l1ChiePTF7EDKwRMX5SLPJ6P6eo6BHISRico6mE="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "follow_event.json" )) , :headers => headers
        expect(response.status).to eq(200)
      end
    end
    
    context 'unfollow event' do
      it 'is blocked' do
        @user = create(:user) 
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "1xyMgax4oMF5gHwU1nxxmMtrF3oLMCuJXl+Q3dbtQCw="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "unfollow_event.json" )) , :headers => headers
        expect(response.status).to eq(200)
      end
    end
    
    context 'postback event' do
      it 'is fest vote step 0' do
        @user = create(:user , talk_status: "10") 
        @fest = create(:fest , fest_status: "10")
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "bXnTZTMthzCl91dnqaV664QwYJNlZOcnorD7GErlLsg="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_vote_st0.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      it 'is fest vote step 1' do
        @user = create(:user , talk_status: "10") 
        @fest = create(:fest)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "/Sx0HybVLk5hPaIMArQOrtjk3MjydrNNN/jAk6iBesA="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_vote_st1.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      it 'is fest vote step 2' do
        @user = create(:user , talk_status: "10") 
        @fest = create(:fest)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "qBNN2ZV8vKnu/FVFUGshmnR2UziYXktg/G0UUbsZ2Kg="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_vote_st2.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      it 'is fest record step 0' do
        @user = create(:user , status: "10" ,talk_status: "11") 
        @fest = create(:fest , fest_status: "10")
        @fest_vote = create(:fest_vote)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "5oqvDl0zdOnR2DVlgfop+xnl8CI9ZbfxDqjpxqwFqWg="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_record_st0.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      it 'is fest record step 1' do
        @user = create(:user , status: "10" ,talk_status: "11") 
        @fest = create(:fest , fest_status: "10")
        @fest_vote = create(:fest_vote)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "0wbJ5T4nHXIg4cJFC8RNghdBJVMzcIiOtOkWjx8D7yY="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_record_st1.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      it 'is fest record step 2' do
        @user = create(:user , status: "10" ,talk_status: "11") 
        @fest = create(:fest , fest_status: "10")
        @fest_vote = create(:fest_vote)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "noZmsND/QhmIL4wtw95TrspUIkAbhp0pNninJrboE9Y="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "fest_record_st2.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end      
    end
    
  end

end
