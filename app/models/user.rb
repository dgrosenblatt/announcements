class User < ActiveRecord::Base
	before_save { self.name = name.downcase }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates 	:name, presence:true, length: { maximum: 50 }, 
				uniqueness: { case_sensitive: false }
	
    validates 	:email, allow_blank:true, format: { with: VALID_EMAIL_REGEX  }

    validates	:password, length: { minimum: 6 }

    has_secure_password
end