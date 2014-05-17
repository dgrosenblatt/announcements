require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index page" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do 
      sign_in user
      visit users_path
    end

    it { should have_title("All Users") }
    it { should have_content("All Users") }

    describe "user count" do
      it { should_not have_selector("h2", text: "Total Users:") }

      describe "as admin" do
        before do
          sign_in(FactoryGirl.create(:admin))
          visit users_path
        end
        it { should have_selector("h2", text: "Total Users:") }
      end
    end


    describe "pagination" do

      before(:all)  { 30.times { FactoryGirl.create(:user) } }
      after(:all)   { User.delete_all }

      it { should have_selector("div.pagination") }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector("li", text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link("delete") }

      describe "as admin" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link("delete", href: user_path(User.first)) }
        it "should be able to delete a user" do
          expect do
            click_link("delete", match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link("delete", href: user_path(admin)) }
      end
    end

  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    describe "as signed in user" do
      let(:user) { FactoryGirl.create(:user) }

      describe "visiting the Signup page" do
        before do
          sign_in user, no_capybara: true
          get signup_path
        end

        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting directly to the Users#create action" do
        let(:params) do
          { user: { name: "SecondAccount", password: "qwer1234", password_confirmation: "qwer1234" } }
        end

        before do
          sign_in user, no_capybara: true
          post users_path, params
        end

        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "verboten attributes" do
      let (:params) { { user: { admin: true, password: user.password, password_confirmation: user.password } } }

      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end

      specify { expect(user.reload).not_to be_admin }

    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link("change", href:"http://gravatar.com/emails") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content("That didn't work") }
    end

    describe "with valid information" do
      let(:new_name) { "newname" }
      let(:new_email) { "newem@ai.l" }

      before do
        fill_in "Display Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_content("Profile updated") }
      it { should have_title(new_name) }
      it { should have_link("Sign out", href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end






