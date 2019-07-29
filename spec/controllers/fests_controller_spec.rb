require 'rails_helper'

RSpec.describe FestsController, type: :controller do

  # describe: テスト対象
  describe 'GET /fests' do
    
    # context: テストする状況、条件
    context 'index' do

      # it: テスト内容を is ~ で記載
      it 'is listing fests' do
        get :index
        
        # HTTPステータスが400であること
        expect(response.status).to eq(200)
      end
    
    end
    
  end
  
  describe 'GET /fest/:id' do
    context 'show' do
      it 'is show fest' do
        @fest = create(:fest)
        get :show , params: { id: 1 }
        expect(response.status).to eq(200)
      end
    end
  end
  
  # 集計
  describe 'POST /fest/:id/totalize' do
    context 'totalize' do
      it 'is fest totalize' do
        @user1 = create(:user, { id: 1 , status: "10" , line_id: "AAAAA"})
        @user2 = create(:user, { id: 2 , status: "10" , line_id: "AAAAA"})
        @user3 = create(:user, { id: 3 , status: "10" , line_id: "AAAAA"})
        @user4 = create(:user, { id: 4 , status: "10" , line_id: "AAAAA"})
        @user5 = create(:user, { id: 5 , status: "10" , line_id: "AAAAA"})
        @user6 = create(:user, { id: 6 , status: "10" , line_id: "AAAAA"})
        @user7 = create(:user, { id: 7 , status: "10" , line_id: "AAAAA"})
        @user8 = create(:user, { id: 8 , status: "10" , line_id: "AAAAA"})
        @user9 = create(:user, { id: 9 , status: "10" , line_id: "AAAAA"})
        @user10 = create(:user, { id: 10 , status: "10" , line_id: "AAAAA"})
        @fest = create(:fest,
            { id: 1 , fest_status: "10" }
            )
        @fest_vote1 = create(:fest_vote , { id: 1 , fest_id: 1 , user_id: 1, selection: "a" , win_rate: 50.00 })
        @fest_vote2 = create(:fest_vote , { id: 2 , fest_id: 1 , user_id: 2, selection: "a" , win_rate: 50.00 })
        @fest_vote3 = create(:fest_vote , { id: 3 , fest_id: 1 , user_id: 3, selection: "a" , win_rate: 50.00 })
        @fest_vote4 = create(:fest_vote , { id: 4 , fest_id: 1 , user_id: 4, selection: "a" , win_rate: 50.00 })
        @fest_vote5 = create(:fest_vote , { id: 5 , fest_id: 1 , user_id: 5, selection: "a" , win_rate: 50.00 })
        @fest_vote6 = create(:fest_vote , { id: 6 , fest_id: 1 , user_id: 6, selection: "b" , win_rate: 50.00 })
        @fest_vote7 = create(:fest_vote , { id: 7 , fest_id: 1 , user_id: 7, selection: "b" , win_rate: 50.00 })
        @fest_vote8 = create(:fest_vote , { id: 8 , fest_id: 1 , user_id: 8, selection: "b" , win_rate: 50.00 })
        @fest_vote9 = create(:fest_vote , { id: 9 , fest_id: 1 , user_id: 9, selection: "b" , win_rate: 50.00 })
        @fest_vote10 = create(:fest_vote , { id: 10 , fest_id: 1 , user_id: 10, selection: "b" , win_rate: 50.00 })
        post :totalize , params: { id: 1 }
        
        expect(@fest.reload.fest_status).to eq("30")
        expect(response.status).to eq(200)
      end
    end
  end
end
