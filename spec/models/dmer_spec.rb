require 'rails_helper'

RSpec.describe Dmer, type: :model do
  before do 
    @dmer = FactoryBot.create(:dmer)
  end 
  describe '案件登録' do 
    context '登録できる時' do 
      it '必要な情報が入っていれば登録できる' do 
        expect(@dmer).to be_valid
      end
    end 
    context '登録できない時' do 
      it 'user_idがない場合は保存できない' do
        @dmer.user_id = nil
        @dmer.valid?
        expect(@dmer.errors.full_messages).to include "獲得者を入力してください"
      end 
      it 'store_prop_idがない場合は保存できない' do 
        @dmer.store_prop_id = nil 
        @dmer.valid?
        expect(@dmer.errors.full_messages).to include "Store propを入力してください"
      end 

      it '獲得日が入力されていない場合は保存できない' do 
        @dmer.date = nil 
        @dmer.valid?
        expect(@dmer.errors.full_messages).to include "獲得日を入力してください"
      end 
      it '獲得日が文字の場合は保存できない' do 
        @dmer.date = '202310-14'
        @dmer.valid? 
        expect(@dmer.errors.full_messages).to include "獲得日を入力してください"
      end 
    end 
  end 
end
