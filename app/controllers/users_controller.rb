class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :favorites]
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  # new と create はセット
  # edit と update もセット
  # new と edit は何か？ → そのための「フォーム」を表示する
  # create と update は何か？ → 実際に登録 or 更新を実行する
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def favorites
    @user = User.find(params[:id])
    @favorites = @user.favorite_posts.page(params[:page])
    counts(@user)
  end
    

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end