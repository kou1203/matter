require 'rails_helper'

describe ActivityBasesController, type: :request do 
  before do 
    @activity_base = FactoryBot.create(:activity_base)
    sign_in @activity_base.user
  end 
  describe 'index' do 
    context 'レスポンスが返ってくる場合' do 
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do 
        get activity_bases_path 
        expect(response.status).to eq 200
      end 
    end 
  end 

end 