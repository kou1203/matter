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
  end 
end
