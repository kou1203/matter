class Form::ProductTargetCollection < Form::Base
  FORM_COUNT = 4 #ここで、作成したい登録フォームの数を指定
  attr_accessor :product_targets 

  def initialize(attributes = {})
    super attributes
    self.product_targets = FORM_COUNT.times.map { ProductTarget.new() } unless self.product_targets.present?
  end

  def product_targets_attributes=(attributes)
    self.product_targets = attributes.map { |_, v| ProductTarget.new(v) }
  end

  def save
    ProductTarget.transaction do
      self.product_targets.map do |product|
        product.save
      end
    end
      return true
    rescue => e
      return false
  end
end