require 'rails_helper'

describe PaypaysController, type: :request do 
  before do 
    @paypay = FactoryBot.create(:paypay)
    sign_in @paypay.user
  end 
  describe 'GET #index' do 
    context 'レスポンスが帰ってくるケース' do 
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do 
        get paypays_path 
        expect(response.status).to eq 200
      end
    end 
    context '正しくレスポンスが帰ってこないケース' do 
      it 'ユーザーの役職が99：退職となっている場合は退職者用のページへ遷移する' do 
        @paypay.user.position_sub = '99：退職'
        get paypays_path 
        expect(response.body).to include ('error_page')
      end
    end 
  end 
end 