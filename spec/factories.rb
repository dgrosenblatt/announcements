FactoryGirl.define do
	factory :user do		# :user corresponds to User model
		name     "Michael Hartl"
	    email    "michael@example.com"
	    password "foobar"
	    password_confirmation "foobar"
	end
end