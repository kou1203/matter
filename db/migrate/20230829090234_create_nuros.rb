class CreateNuros < ActiveRecord::Migration[6.1]
  def change
    create_table :nuros do |t|

      t.string :controll_num                      ,null: false 
      t.references :user                          ,foreign_key: true 
      t.string :last_name_kana
      t.string :prefecture
      t.date :date                                ,null: false 
      t.string :status                          
      t.text :remarks
      t.string :status_after_call
      t.string :status_progress
      t.string :status_antena
      t.date :start
      t.date :revoke
      t.date :cancel
      t.string :current_month_cancel
      t.string :option_tell
      t.date :option_hikari_tv
      t.date :option_hikari_tv2
      t.date :option_seiton_and_hozon
      t.date :option_seiton_and_hozon_cancel
      t.string :option_seiton_and_hozon_flag
      t.date :option_nuro_hikari_safe
      t.date :option_nuro_hikari_safe_cancel
      t.string :option_nuro_hikari_safe_flag
      t.date :option_nuro_sakutto_support
      t.date :option_nuro_sakutto_support_cancel
      t.string :option_nuro_sakutto_support_flag
      t.date :option_tokutoku_super
      t.date :option_tokutoku_super_cacnel
      t.string :option_tokutoku_super_flag
      t.date :option_nuro_smart_life
      t.date :option_nuro_smart_life_cancel
      t.string :option_nuro_smart_life_flag
      t.date :option_tsunagaru_mesh_wifi
      t.date :option_tsunagaru_mesh_wifi_cancel
      t.string :option_tsunagaru_mesh_wifi_flag
      t.string :isp_num
    end
  end
end
