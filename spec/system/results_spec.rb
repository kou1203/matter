require 'rails_helper'

RSpec.describe '終着入力のテスト', type: :system do
  before do 
    @result = FactoryBot.create(:result)
    sign_in @result.user
  end 
  describe '表示テスト' do 
    context '新規入力画面' do 
      before do 
        visit new_result_path(user_id: @result.user_id, date: @result.date)
      end 
      it '登録ボタンが表示されている' do 
        expect(page).to have_button '登録'
      end 
    end
    context '新規シフトの場合' do 
      before do 
        visit new_result_path(user_id: @result.user_id, date: @result.date)
      end 
      it '基準値を入力するフォームが表示される' do 
        select(value='キャッシュレス新規', from: "result[shift]")
        expect(page.body).to include '基準値'
      end 
      it '店舗基準値を入力するフォームが表示される' do 
        select(value='キャッシュレス新規', from: "result[shift]")
        expect(page.body).to include '店舗別基準値'
      end 
      it '時間別基準値を入力するフォームが表示される' do 
        select(value='キャッシュレス新規', from: "result[shift]")
        expect(page.body).to include '時間帯別基準値'
      end 
    end 
  end 
end 