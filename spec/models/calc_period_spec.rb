require 'rails_helper'

RSpec.describe CalcPeriod, type: :model do
  before do 
    @calc_period = FactoryBot.build(:calc_period)
  end 
  describe '登録' do
    context '登録できる時' do 
      it '必要な項目が入力されていれば登録できる。' do 
        expect(@calc_period).to be_valid
      end 
    end 
    context '登録できない時' do 
      it '開始月に2より上の数値が入っていると登録できない' do 
        @calc_period.start_date_month = 3
        @calc_period.valid? 
        expect(@calc_period.errors.full_messages).to include "Start date monthは2以下の値にしてください"
      end 
      it '開始日に30より上の数値が入っていると登録できない' do 
        @calc_period.start_date_day = 31
        @calc_period.valid?
        expect(@calc_period.errors.full_messages).to include "Start date dayは30以下の値にしてください"
      end 
      it '終了月に2より上の数値が入っていると登録できない' do 
        @calc_period.end_date_month = 3
        @calc_period.valid? 
        expect(@calc_period.errors.full_messages).to include "End date monthは2以下の値にしてください"
      end 
      it '終了日に30より上の数値が入っていると登録できない' do 
        @calc_period.end_date_day = 31
        @calc_period.valid?
        expect(@calc_period.errors.full_messages).to include "End date dayは30以下の値にしてください"
      end 
      it '締めの月に2より上の数値が入っていると登録できない' do 
        @calc_period.closing_date_month = 3
        @calc_period.valid? 
        expect(@calc_period.errors.full_messages).to include "Closing date monthは2以下の値にしてください"
      end 
      it '締めの日に30より上の数値が入っていると登録できない' do 
        @calc_period.closing_date_day = 31
        @calc_period.valid?
        expect(@calc_period.errors.full_messages).to include "Closing date dayは30以下の値にしてください"
      end 
    end 
  end 
end
