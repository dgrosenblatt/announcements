module SessionsHelper

	def signin_user(user)
		remember_token = User.create_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.hash_token(remember_token))
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		hashed_token = User.hash_token(cookies[:remember_token])
		@current_user ||= User.find_by(:remember_token => hashed_token)
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		current_user.update_attribute(:remember_token, User.hash_token(User.create_token))
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end
end
