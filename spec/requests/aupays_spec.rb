require 'rails_helper'

describe AupaysController, type: :request do 
  before do 
    @aupay = FactoryBot.create(:aupay)
    sign_in @aupay.user
  end 
  describe 'GET #index' do 
    context 'レスポンスが返ってくる場合' do 
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do 
        get aupays_path 
        expect(response.status).to eq 200
      end 
    end 
    context 'レスポンスが返ってこない場合' do 
      it 'ユーザーの役職が99：退職となっている場合は退職者用のページへ遷移する' do 
        @aupay.user.position_sub = '99：退職'
        get aupays_path 
        expect(response.body).to include 'error_pages'
      end 
    end 

  end

  # describe 'import' do 
  #   context 'importできるケース' do 
  #     before do 
  #       @store_prop = FactoryBot.create(:store_prop)
  #       @user = FactoryBot.create(:user)
  #     end 
  #     let(:csv_file) {'test.csv'}
  #     subject do
  #       post import_aupays_path, params: {
  #         csv_file: fixture_file_upload(csv_file, 'text/csv')
  #       }  
  #     end
  #     it 'import_csv' do
  #       expect{subject}.to change(Aupay,:count).by(1)
  #     end
  #   end 
  # end  
end 