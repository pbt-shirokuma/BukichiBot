class FestVotesController < ApplicationController
  before_action :set_fest_vote, only: [:edit, :update]
  
  # post '/fest_vote'
  def create
    fest_vote = FestVote.new(
      fest_id: params[:fest_id],
      user_id: @current_user.id,
      selection: params[:selection]
    )
    if fest_vote.save
      redirect_to :action => 'edit', :id => fest_vote.id, :notice => "フェスに投票しました！"
    else
      redirect_to fest_path(id: params[:fest_id]), notice: fest_vote.errors.full_messages
    end
  end
  
  # get '/fest_votes/:id/edit'
  def edit; end
  
  # post '/fest_votes/:id'
  def update
    if params[:result].present?
      @fest_vote.game_count += 1
      @fest_vote.win_count += 1 if params[:result] == 'win'
    end
    @fest_vote.assign_attributes(fest_vote_params)
    @fest_vote.win_rate = @fest_vote.win_count.quo(@fest_vote.game_count).to_f
    if @fest_vote.save
      render action: 'edit', notice: "結果を反映しました！"
    else
      render action: 'edit', notice: "結果の反映に失敗しました。"
    end
  end
  
  private
  
  # Only allow a trusted parameter "white list" through.
  def fest_vote_params
    params.fetch(:fest_vote, {}).permit(:selection, :win_count, :game_count)
  end
  
  def set_fest_vote
    @fest_vote = FestVote.find(params[:id])
  end
end
