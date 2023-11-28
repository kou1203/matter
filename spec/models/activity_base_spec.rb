require 'rails_helper'

RSpec.describe ActivityBase, type: :model do
  before do 
    @activity_base = FactoryBot.create(:activity_base)
  end 
  describe '登録' do 
    context '登録できる場合' do 
      it '必要な情報が保存されれば登録できる' do 
        expect(@activity_base).to be_valid
      end 
    end 
    context '登録できない場合' do 
      it '登録日が入力されていない場合登録できない' do 
        @activity_base.date = nil
        @activity_base.valid?
        expect(@activity_base.errors.full_messages).to include "登録日を入力してください"
      end 
      it 'ユーザーが入力されてない場合登録できない' do 
        @activity_base.user_id = nil
        @activity_base.valid?
        expect(@activity_base.errors.full_messages).to include "Userを入力してください"
      end 
      it '拠点が入力されてない場合登録できない' do 
        @activity_base.base = nil
        @activity_base.valid?
        expect(@activity_base.errors.full_messages).to include "を入力してください"
      end 
      it '役職が入力されてない場合登録できない' do 
        @activity_base.position = nil
        @activity_base.valid?
        expect(@activity_base.errors.full_messages).to include "役職を入力してください"
      end 
    end 
  end 
end
