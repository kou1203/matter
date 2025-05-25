class ResultType < ApplicationRecord
  belongs_to :result
  has_many :deal_attributes, inverse_of: :result_type, dependent: :destroy
  # これがネストされたフォームから子を保存するための設定
  accepts_nested_attributes_for :deal_attributes, allow_destroy: true
  with_options presence: true do 
    validates :result_id
    validates :visit_type
  end
end
