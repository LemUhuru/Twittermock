module SessionsHelper

	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
		self.current_user = user
		# Self in the above context references the 'Module' as it would a class
		# if the method was nested in one. Absent self, we would be assigning the user
		# to a local variable rather than the setter method within the SessionsHelper module.
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def sign_out
		current_user.update_attribute(:remember_token,
											User.digest(User.new_remember_token)) 
		cookies.delete(:remember_token)
		self.current_user = nil
	end
end
