class SessionController < ApplicationController
  skip_before_action :require_sign_in!, on: [:new, :create]
  
  # get /
  def new
    session[:user_id] = nil
    @last_login_user = User.find_by(account_token: cookies[:account_token]) if cookies[:account_token].present?
  end

  # post /login
  def create
    account_token = cookies[:account_token]
    if params[:name].present? && account_token.present?
      # トークンがあればユーザー持ってくる
      user = User.find_by(name: params[:name], account_token: account_token )
      unless user.present?
        redirect_to new_session_path, notice: "ユーザーが見つかりませんでした" and return 
      end
    else
      # トークンがなければ、ユーザーを作る
      user = User.new(name: params[:name])
      if user.valid?
        user.save
        cookies.permanent[:account_token] = user.account_token
      else
        redirect_to new_session_path, notice: "ユーザー名を入力してください" and return 
      end
    end
    session[:user_id] = user.id
    redirect_to controller: 'fests', action: 'index'
  end

  # post /logout
  def destroy
    session[:user_id] = nil
    redirect_to action: 'new'
  end
  
  # patch /reset_account_token
  def reset_account_token
    cookies[:account_token] = nil
    redirect_to action: 'new'
  end

end
