require 'rails_helper'

describe ResultsController,type: :request do 

  before do 
    @result = FactoryBot.create(:result)
    @user = FactoryBot.create(:user)
    sign_in @user
  end 
  describe "GET #index" do 
    context 'レスポンスが返ってくる場合' do
      it "indexアクションにリクエストすると正常にレスポンスが帰ってくる" do 
        get root_path
        expect(response.status).to eq 200
      end 
    end
    context 'レスポンスが返ってこない場合' do 
      it 'ユーザーの役職が99：退職となっている場合は退職者用のページへ遷移する' do
        @user.position_sub = '99：退職'
        get root_path 
        expect(response.body).to include "error_pages"
      end
    end  

  end

end 