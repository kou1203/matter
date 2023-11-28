require 'rails_helper'

RSpec.describe '終着入力のテスト', type: :system do
  before do 
    @result = FactoryBot.create(:result)
    sign_in @result.user
  end 
  describe '表示テスト' do 
    context '新規シフトの場合' do 
      before do 
        visit new_result_path(user_id: @result.user_id, date: @result.date)
      end 
      it '基準値を入力するフォームが表示される' do 
        expect(page.body).to include '基準値'
      end 
      it '店舗基準値を入力するフォームが表示される' do 
        expect(page.body).to include '店舗別基準値'
      end 
      it '時間別基準値を入力するフォームが表示される' do 
        expect(page.body).to include '時間帯別基準値'
      end 
      it '登録ボタンが表示されている' do 
        expect(page).to have_button '登録'
      end 
      it '入力すると入力すると保存され、切り返しの入力画面へ遷移する' do
        # 必要な項目を入力
        fill_in 'result[date]', with: Date.today
        fill_in 'result[area]', with: 'hoge'
        select(value='キャッシュレス新規', from: 'result[shift]')
        expect{find('input[name=commit]').click}.to change { Result.count }.by(1)
        # 必要な項目が入力された状態で登録ボタンを押したら切り返しの入力項目へ移動するか
        expect(current_path).to eq(result_result_cashes_new_path(@result.id + 1))
      end
    end 
  end 
end 