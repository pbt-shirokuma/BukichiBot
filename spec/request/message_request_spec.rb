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
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "lJYCsaxP6KxCMH9LJT6vU/emb+X1kpgKKVt8L03MYeU="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "weapon_name_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is received weapon roulette message' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "VIa/ybpsGXgg0boWL5Ix0/la3x/oOXtfSYnBq4h/CQQ="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "weapon_roulette_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is received sticker message' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "vrucXT2fn176VYTE+cIkvVyCZmx6zZkbDle7KFUXCOo="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "sticker_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
        
      it 'is received image/video message' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "mULImoFBGN19sfDmPmTyByEybECxvbirS6nCjzdNW5I="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "image_message.json" )) , :headers => headers
        
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
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => true)
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
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "1xyMgax4oMF5gHwU1nxxmMtrF3oLMCuJXl+Q3dbtQCw="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "unfollow_event.json" )) , :headers => headers
        expect(response.status).to eq(200)
      end
    end
      
  end

end
