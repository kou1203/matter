require 'rails_helper'

RSpec.describe User, type: :model do
  before do 
    @user = FactoryBot.build(:user)
  end 

  describe '新規登録' do 
    context '新規登録ができる時' do 
      it '名前, メアド, パスワード, パスワード確認用が入力されていれば登録できる' do 
        expect(@user).to be_valid
      end
    end 

    context '新規登録できない時' do 
      it 'メールアドレスが空だと登録できない' do 
        @user.email = ''
        @user.valid? 
        expect(@user.errors.full_messages).to include "Emailを入力してください"
      end 

      it '同じメールアドレスがあると登録できない' do 
        user_another = FactoryBot.build(:user)
        user_another.save 
        @user.email = user_another.email
        @user.valid?
        expect(@user.errors.full_messages).to include "Emailはすでに存在します"
      end 

      it 'メールアドレスは、@を含まないと登録できない' do 
        @user.email = 'test.gmail.com'
        @user.valid? 
        expect(@user.errors.full_messages).to include "Emailは不正な値です"
      end 

      it 'パスワードとパスワード（確認用）は一致していないと登録できない' do 
        @user.password = '12345a'
        @user.password_confirmation = '12345b'
        @user.valid? 
        expect(@user.errors.full_messages).to include "Password confirmationとPasswordの入力が一致しません"
      end
    end 

  end 
end
