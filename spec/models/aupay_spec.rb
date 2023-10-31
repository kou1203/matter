require 'rails_helper'

RSpec.describe Aupay, type: :model do 
  before do 
    @aupay = FactoryBot.create(:aupay)
  end 
  describe '登録' do 
    context '登録できる場合' do 
      it '必要な情報が入力されていれば登録できる' do 
        expect(@aupay).to be_valid
      end
    end 
    context '登録できない場合' do 
      it '獲得日が入力されていないと登録できない' do 
        @aupay.date = nil 
        @aupay.valid? 
        expect(@aupay.errors.full_messages).to include '獲得日を入力してください'
      end 
      it '獲得者のIDが入力されていないと登録できない' do 
        @aupay.user_id = nil 
        @aupay.valid? 
        expect(@aupay.errors.full_messages).to include '獲得者を入力してください'
      end 
      it '店舗情報のIDが入力されていないと登録できない' do 
        @aupay.store_prop_id = nil 
        @aupay.valid?
        expect(@aupay.errors.full_messages).to include 'Store propを入力してください'
      end 
      it '審査ステータスの入力がないと登録できない' do 
        @aupay.status = nil 
        @aupay.valid?
        expect(@aupay.errors.full_messages).to include 'Statusを入力してください'
      end 
      it '評価売の単価（新規）が入力されていないと登録できない' do 
        @aupay.valuation_new = nil 
        @aupay.valid? 
        expect(@aupay.errors.full_messages).to include '評価売上（新規）を入力してください'
      end 
      it '実売の単価（新規）が入力されていないと登録できない' do 
        @aupay.profit_new = nil 
        @aupay.valid?
        expect(@aupay.errors.full_messages).to include '実売上（新規）を入力してください'
      end 
      it '評価売の単価（決済）が入力されていないと登録できない' do 
        @aupay.valuation_settlement = nil 
        @aupay.valid? 
        expect(@aupay.errors.full_messages).to include '評価売上（決済）を入力してください'
      end 
      it '実売の単価（決済）が入力されていないと登録できない' do 
        @aupay.profit_settlement = nil 
        @aupay.valid?
        expect(@aupay.errors.full_messages).to include '実売上（決済）を入力してください'
      end 
    end
  end 

end  