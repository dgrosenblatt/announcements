class User < ActiveRecord::Base
	before_save :prepare_name_for_db
	before_create :create_remember_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates 	:name, presence:true, length: { maximum: 50 }, 
				uniqueness: { case_sensitive: false }
	
    validates 	:email, allow_blank:true, format: { with: VALID_EMAIL_REGEX  }

    validates	:password, length: { minimum: 6 }

    has_secure_password

    def User.create_token
		SecureRandom::urlsafe_base64
	end

	def User.hash_token(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private

		def prepare_name_for_db
			self.name = name.downcase
		end

		def create_remember_token
			self.remember_token = User.hash_token(User.create_token)
		end
end
