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

		it { should_not have_link("Sign out", href: signout_path) }
		it { should_not have_link("Profile") }
		it { should_not have_link("Settings") }
		it { should_not have_link("Users", href: users_path) }

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
		it { should have_link("Settings", href: edit_user_path(user)) }
		it { should have_link("Users", href: users_path) }
		it { should have_content(user.name) }
		it { should_not have_content("Sign in") }
	end

	describe "authorization" do
		describe "for non-signed in users" do
			let(:user) { FactoryGirl.create(:user) }
			let(:second_user) { FactoryGirl.create(:user, name: "Mister Plow") }

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					fill_in "Display Name", with: user.name
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				it { should have_content("Update your profile") }
			end

			describe "in the users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title("Sign in") }
				end

				describe "visiting the users index" do
					before { visit users_path }
					it { should have_title("Sign in") }
				end

				describe "submitting to the update action" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end

			describe "with the wrong user" do
				before { sign_in(second_user, no_capybara: true) }

				describe "visiting another user's edit page" do
					before { get edit_user_path(user) }
					specify { expect(response.body).not_to match(full_title('Edit user')) }
        			specify { expect(response).to redirect_to(root_url) }
				end

				describe "submitting to the update action" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(root_url) }
				end
			end
		end

		describe "as an admin user" do
			let(:admin) { FactoryGirl.create(:admin) }
			describe "deleting self with DELETE request to Users#destroy action" do
				before do
					sign_in admin, no_capybara: true
					delete user_path(admin)
				end
				specify { expect(response).to redirect_to(root_url) }
			end
		end

	    describe "as non-admin user" do
	      let(:user) { FactoryGirl.create(:user) }
	      let(:non_admin) { FactoryGirl.create(:user) }

	      before { sign_in non_admin, no_capybara: true }

	      describe "submitting a DELETE request to the Users#destroy action" do
	        before { delete user_path(user) }
	        specify { expect(response).to redirect_to(root_url) }
	      end
	    end
	end
end