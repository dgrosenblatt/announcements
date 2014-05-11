class SessionsController < ApplicationController

	def new
		# nothing to do here, other than render the page? ok!
	end

	def create
		@user = User.find_by_name(params[:session][:name].downcase)
		if @user && @user.authenticate(params[:session][:password])
			flash.now[:success] = "Welcome back."
			signin_user(@user)
			redirect_back_or @user 		# polymorphism? it knows where to go for some reason
		else
			flash.now[:danger] = "Display Name and/or Password incorrect."
			render 'new'
		end
	end

	def destroy
		sign_out
		flash[:info] = "Successfully signed out."
		redirect_to root_url
	end
end
