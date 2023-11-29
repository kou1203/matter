require 'rails_helper'

describe SelectColumnsController, type: :request do 
  describe 'Get#new' do 
    before do 
      @user = FactoryBot.create(:user)
      sign_in @user
    end 
    context '登録画面へ遷移できる' do 
      it 'newアクションへリクエストしたら正常にレスポンスが返ってくる' do 
        get new_select_column_path(category: "テスト")
        expect(response.status).to eq 200
      end
    end 
  end
end 