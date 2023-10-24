require 'rails_helper'

RSpec.describe '終着入力', type: :system do
  before do 
    @result = FactoryBot.create(:result)
  end 
  context '新規と決済以外のシフトを入力した時' do 
    it 'ログインしたユーザーは終着を入力できる' do
      # ログインする
      sign_in(@result.user)
      # 終着のページへ遷移する。
      visit new_result_path(user_id: @result.user_id, date: @result.date)
      # 終着を入力する
      fill_in @result.date, with: 'hoge'
      fill_in @result.shift, with: '帯同'

      expect{
        find('input[name="commit"]').click

      }.to change { Result.count }.by(1)

      #終着を登録したらトップページへ遷移する。
      expect(current_path).to eq(root_path)
    end
  end 
end 