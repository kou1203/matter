require 'rails_helper'

RSpec.describe StoreProp, type: :model do
  before do 
    @store_prop = FactoryBot.build(:store_prop)
  end 
  describe '案件登録' do
    context '登録できる時' do 
      it '必要な情報が入っていれば登録できる' do 
        expect(@store_prop).to be_valid
      end 
    end 
  end 
end
