class FestsController < ApplicationController
  before_action :set_fest, only: [:show, :edit, :update , :totalize]

  # GET /fests
  def index
    @fests = Fest.all
  end

  # GET /fests/1
  def show
    
  end

  # GET /fests/new
  def new
    @fest = Fest.new
  end

  # GET /fests/1/edit
  def edit

  end

  # POST /fests
  def create
    @fest = Fest.new(fest_params)
    @fest.user = @current_user
    if @fest.save
      redirect_to @fest, notice: 'Fest was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /fests/1
  def update
    if @fest.update(fest_params)
      redirect_to @fest, notice: 'Fest was successfully updated.'
    else
      render :edit
    end
  end

  # PATCH/PUT /fests/1/totalize
  # 集計処理
  def totalize
    
    # 集計中に更新する
    @fest.fest_status = Fest::FEST_STATUS[:totalize]
    unless @fest.save
      # 更新できなかった場合
      render :show
      return
    end
    
    # フェスに参加したユーザーのLINE_IDをリスト化する
    fest_voted_users = []
    @fest.fest_votes.each do |fest_vote|
      if fest_vote.user.status == User::STATUS[:fest]
        fest_voted_users.push(fest_vote.user)
      end
    end
    
    team_a_win_rate = nil
    team_b_win_rate = nil
    win_team = nil
    
    # トランザクションを開始する
    ActiveRecord::Base.transaction do
      team_a_win_rate = 
        FestVote.where(["fest_id = ? and selection = 'a'",1])
          .average(:win_rate).to_f.round(2)
        
      team_b_win_rate = 
        FestVote.where(["fest_id = ? and selection = 'b'",1])
          .average(:win_rate).to_f.round(2)  
      
      # 勝敗の記録
      if team_a_win_rate > team_b_win_rate
        @fest.fest_result = "a"
        win_team = @fest.selection_a + "の勝ち"
      elsif team_a_win_rate < team_b_win_rate
        @fest.fest_result = "b"
        win_team = @fest.selection_b + "の勝ち"
      else
        @fest.fest_result = "draw"
        win_team = "引き分け"
      end
      
      @fest.fest_status = Fest::FEST_STATUS[:close]
      @fest.save!
      
      # ユーザーのステータスを「通常」に戻す
      fest_voted_users.each do |user|
        user.update_attributes!(status: User::STATUS[:normal])
      end
      
    end
    
    messages = []
    
    messages.push({
      type: "text",
      text: "フェスが終了したでし！\n結果は・・・"
    })
    messages.push({
      type: "text",
      text: @fest.selection_a + "チームの勝率:" + team_a_win_rate.to_s
    })
    messages.push({
      type: "text",
      text: @fest.selection_b + "チームの勝率:" + team_b_win_rate.to_s
    })
    messages.push({
      type: "text",
      text: win_team + "でし！\nみんなよく頑張ったでし！"
    })
    
    # フェスの結果を参加者にPush通知する
    fest_voted_users.each do |user|
      client.push_message(user.line_id, messages)
    end
      
    render :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fest
      @fest = Fest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fest_params
      case action_name
      when "create"
        params.fetch(:fest, {}).permit(:fest_name , :fest_status , :selection_a , :selection_b)
      when "update"
        params.fetch(:fest, {}).permit(:fest_name , :fest_status , :selection_a , :selection_b , :fest_result)
      end
    end
    
    # Line clientの定義
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_id = ENV["LINE_CHANNEL_ID"]
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
end
