class UsersController < ApplicationController
  before_action :signed_out_user, only: [:new, :create]
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
  	@user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
    @count = User.count
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      signin_user(@user)
      flash[:success] = "Welcome to the thing."
  		redirect_to @user # equivalent to user_path(@user.id)
  	else
  		render 'new'		
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash.now[:success] = "Profile updated."
      render 'show'
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to root_url
    else
      @user.destroy
      flash[:success] = "Deleted."
      redirect_to users_path
    end
  end



  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #Before filters

    def signed_out_user
      if signed_in?
        redirect_to root_url
      end
    end

    def signed_in_user
      if !signed_in?
        flash[:info] = "Please sign in."
        store_location
        redirect_to signin_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      if @user != current_user
        redirect_to root_url
      end
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
  
end
