require 'rails_helper'

RSpec.describe Paypay, type: :model do
  before do 
    @paypay = FactoryBot.create(:paypay)
  end

  describe '案件登録' do
    context '登録できる時' do 
      it '必要な情報が入力されていれば登録できる。' do 
        expect(@paypay).to be_valid 
      end
    end
    context '登録できない時' do 
      it '商流が入力されていないと登録できない。' do 
        @paypay.client = nil 
        @paypay.valid? 
        expect(@paypay.errors.full_messages).to include "商流を入力してください"
      end 
      it '日付が入力されていないと登録できない。' do 
        @paypay.date = nil 
        @paypay.valid? 
        expect(@paypay.errors.full_messages).to include "獲得日を入力してください"
      end 
      it '審査ステータスが入力されていないと登録できない。' do 
        @paypay.status = nil 
        @paypay.valid? 
        expect(@paypay.errors.full_messages).to include "審査ステータスを入力してください"
      end 
      it '実売が入力されていないと登録できない。' do 
        @paypay.profit = nil 
        @paypay.valid? 
        expect(@paypay.errors.full_messages).to include "実売を入力してください"
      end 
      it '評価売が入力されていないと登録できない。' do 
        @paypay.valuation = nil 
        @paypay.valid? 
        expect(@paypay.errors.full_messages).to include "評価売を入力してください"
      end 
    end 
  end 
  
end
