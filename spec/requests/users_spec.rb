require 'rails_helper'

describe UsersController ,type: :request do
  before do 
    @user = FactoryBot.create(:user)
  end 
  describe " " do 
    it "ログインがメインへ移動" do 
      visit new_user_session_path
    end 
  end 
end 