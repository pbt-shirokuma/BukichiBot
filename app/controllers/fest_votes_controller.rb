class FestVotesController < ApplicationController
    
  # post '/fest_vote'
  def create
    fest_vote = FestVote.create!(
      fest_id: params[:id],
      user_id: @current_user.id,
      selection: params[:selection]
    )
    redirect_to :action => 'edit', :id => fest_vote.id, :notice => "フェスに投票しました！"
  end
  
  # get '/fest_votes/:id/edit'
  def edit
    @fest_vote = FestVote.find(params[:id])
  end
  
  # post '/fest_votes/:id'
  def update
    @fest_vote = FestVote.find(params[:id])
    @fest_vote.game_count += 1
    @fest_vote.win_count += 1 if params[:result] == 'win'
    @fest_vote.win_rate = @fest_vote.win_count.quo(@fest_vote.game_count).to_f
    if @fest_vote.save!
      redirect_to action: 'edit', notice: 'Fest was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  private
  
  # Only allow a trusted parameter "white list" through.
  def fest_vote_params
    params.fetch(:fest_vote, {}).permit(:selection)
  end
end
