require 'rails_helper'

RSpec.describe SelectColumn, type: :model do
  describe '登録テスト' do 
    before do 
      @select_column = FactoryBot.create(:select_column)
    end 
    context '登録できる時' do 
      it '必要な情報が入力されていれば保存できる' do 
        expect(@select_column).to be_valid
      end 
    end 
    context '登録できない時' do 
      it 'カテゴリーの入力がない場合保存できない' do 
        @select_column.category = nil
        @select_column.valid?
        expect(@select_column.errors.full_messages).to include "カテゴリーを入力してください"
      end 
      it '名称の入力がない場合保存できない' do 
        @select_column.name = nil
        @select_column.valid?
        expect(@select_column.errors.full_messages).to include "名称を入力してください"
      end 

    end 
    
  end 
end
