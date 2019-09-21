class SessionController < ApplicationController
  skip_before_action :require_sign_in!, on: [:new, :create]
  
  # get /
  def new
    session[:user_id] = nil
    @user = User.new()
  end

  # post /login
  def create
    account_token = cookies[:account_token]
    if params[:name].present? && account_token.present?
      # トークンがあればユーザー持ってくる
      user = User.find_by(name: params[:name], account_token: account_token )
      unless user.present?
        flash[:errors] = "no data found"
        render "new" and return 
      end
    else
      # トークンがなければ、ユーザーを作る
      account_token = User.new_account_token
      user = User.create(name: params[:name], account_token: account_token).reload
      cookies.permanent[:account_token] = account_token
    end
    session[:user_id] = user.id
    redirect_to controller: 'fests', action: 'index'
  end

  # post /logout
  def destroy
    session[:user_id] = nil
    redirect_to action: 'new'
  end

end
