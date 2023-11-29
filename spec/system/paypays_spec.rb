require 'rails_helper'

RSpec.describe 'PayPayのViewテスト',type: :system do 
    before do 
      @paypay = FactoryBot.create(:paypay)
      sign_in @paypay.user
    end 
    describe '登録画面の表示テスト' do 
      before do 
        visit new_paypay_path(store_id: @paypay.store_prop_id)
      end 
      context '新規登録ページ' do 
        it '登録ボタンが表示されている' do 
          expect(page.body).to include "登録"
        end 
        it '商流を入力する項目が表示される' do 
          select(value="マックスサポート",from: "paypay[client]")
          expect(page.body).to include "商流"
        end 

        it '獲得日を入力するページが表示される' do 
          expect(page.body).to include "paypay[date]"
        end 

        it '獲得者を入力するページが表示される' do 
          expect(page.body).to include "paypay[user_id]"
        end 
      end 
    end 
end 