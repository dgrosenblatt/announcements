require 'spec_helper'

describe "Authentication" do
	
  	subject { page }

	describe "sign in page" do

		before { visit signin_path }

		it { should have_selector("h1", "Sign in") }
		it { should have_title("Sign in") }
	end

	describe "sign in with invalid information" do

		before do
			visit signin_path
			click_button "Sign in"
		end

		it { should have_title("Sign in") }
		it { should have_selector("div.alert.alert-danger.alert-dismissable") }

		describe "visit another page after invalid sign in" do
			before { visit root_path }
			it { should_not have_selector("div.alert.alert-danger.alert-dismissable") }
		end
	end

	describe "sign in with valid information" do
		let(:user ) { FactoryGirl.create(:user) }
		before do
			visit signin_path
			fill_in "Display Name", with: user.name
			fill_in "Password", with: user.password
			click_button "Sign in"
		end

		it { should have_link("Sign out", href: signout_path) }
		it { should have_link("Profile", href: user_path(user)) }
		it { should have_content(user.name) }
		it { should_not have_content("Sign in") }
	end
end