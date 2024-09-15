class Form::ResultCashCollection < Form::Base
  FORM_COUNT = 3 #ここで、作成したい登録フォームの数を指定
  attr_accessor :result_cashes

  def initialize(attributes = {})
    super attributes
    self.result_cashes = FORM_COUNT.times.map { ResultCash.new() } unless self.result_cashes.present?
  end

  def result_cashes_attributes=(attributes)
    self.result_cashes = attributes.map { |_, v| ResultCash.new(v) }
  end

  def save
    ResultCash.transaction do
      self.result_cashes.map do |product|
        product.save
      end
    end
      return true
    rescue => e
      return false
  end
end