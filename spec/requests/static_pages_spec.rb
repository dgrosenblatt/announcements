require 'spec_helper'

describe "Static pages" do

  it "should have the right links" do
  	visit root_path
  	click_link "About"
  	expect(page).to have_selector('h1', 'About')
  	visit root_path
  	click_link "Contact"
  	expect(page).to have_selector('h1', 'Contact')
  	visit root_path
  	click_link "Help"
  	expect(page).to have_selector('h1', 'Help')
  	visit root_path
  	click_link "Sign up now!"
  	expect(page).to have_selector('h1', 'Sign up')
  end	

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "events page" do
    before { visit events_path }

    let(:heading)       { "Events" }
    let(:page_title )   { "Events" }

    it_should_behave_like "all static pages"
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Announciator' }
    let(:page_title) { '' }

    it { should have_content("paying attention")}
    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)		{ 'About' }
    let(:page_title)	{ 'About' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let (:heading)		{ 'Contact' }
    let (:page_title)	{ 'Contact' }
  end
end