class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index, show, edit, update, destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_or_correct, only: %i(show)
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def show
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
    case @user.id
    when 1, 2, 3
      flash[:danger] = "このユーザーは編集できません。"
      redirect_to @user
    end
  end
   
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    case @user.id
    when 1, 2, 3
      flash[:danger] = "このユーザーは削除できません。"
      redirect_to users_url
    else
      @user.destroy
      flash[:success] = "#{@user.name}のデータを削除しました。"
      redirect_to users_url
    end
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
  
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # 現ログインユーザーであるか
  def correct_user
    redirect_to root_url unless current_user?(@user)
  end
  
  # @userが定義されている上で使用する
  def admin_or_correct
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "権限がありません。"
      redirect_to root_url
    end  
  end
end
