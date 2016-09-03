require 'rails_helper'

describe "Sign up with Facebook", :type => :feature, :js => true do
  describe "without selecting a Role" do
    before do
      visit new_user_registration_path
      click_link 'facebook-login'
    end

    it "should render a validation error" do
      expect(page).to have_text("can\'t be blank")
    end
  end
end
