require 'rails_helper'

RSpec.describe Result, type: :model do
  before do 
    @result = FactoryBot.create(:result)
  end 
  describe '案件登録' do 
    context '登録できる時' do 
      it '必要な情報が入力されていれば登録できる' do 
        expect(@result).to be_valid 
      end 
      it '帯同者IDがなくても登録できる' do 
        @result.ojt_id = nil 
        expect(@result).to be_valid
      end 
    end 
    context '登録できない時' do 
      it 'ユーザーIDがないと登録できない' do 
        @result.user_id = nil
        @result.valid?
        expect(@result.errors.full_messages).to include '報告訪問員名を入力してください'
      end 
      it '日付の入力がないと登録できない' do 
        @result.date = nil
        @result.valid? 
        expect(@result.errors.full_messages).to include '日付を入力してください'
      end 
      it 'シフトの入力がないと登録できない' do 
        @result.shift = nil 
        @result.valid?
        expect(@result.errors.full_messages).to include 'シフトを入力してください'
      end 
      it 'エリアの入力がないと登録できない' do 
        @result.area = nil
        @result.valid? 
        expect(@result.errors.full_messages).to include '地域を入力してください'
      end 

    end 
  end 
end
