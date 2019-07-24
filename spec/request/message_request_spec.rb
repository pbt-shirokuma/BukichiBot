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
          "X-Line-Signature" => "7lo54FqoBYq2tBkThpTeoqu65l8EEKgk3biTE1OOYDk="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "weapon_name_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is received weapon roulette message' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "AxXHd6BNQGwTYow2daHyfJwohPt+pMB31lR/NMdCc7o="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "weapon_roulette_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is received sticker message' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "e666e189Ayt6LX/eW/VHIeBzQNQLdnyBafHLJYl3Xhs="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "sticker_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
        
      it 'is received image/video message' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "l83WLZ3CZyHTDc3W43s7g4hrVz5rr8CLH0OKGTwC/ts="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "image_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
    end
    
    context 'follow event' do
      it 'is new follower add' do
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "AQLg3h9hKidVQFNr5rr1oJPiF5fac7Jj9UNyWohU2dM="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "follow_event.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end

      it 'is block cancel' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604ccc' , :status => '00' , :del_flg => true)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "AQLg3h9hKidVQFNr5rr1oJPiF5fac7Jj9UNyWohU2dM="
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
          "X-Line-Signature" => "JPiOQpKDC1YgOUlA/rfTND5wwL2m/YQ4uOvpODgXOFw="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "unfollow_event.json" )) , :headers => headers
        expect(response.status).to eq(200)
      end
    end
      
  end

end
