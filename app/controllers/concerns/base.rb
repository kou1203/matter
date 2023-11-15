module Base 
  extend ActiveSupport::Concern
  included do 
  end 

  def bases
    @bases = ["中部SS","関西SS","関東SS","九州SS","2次店"]
    @progress_bases = ["中部SS","関西SS","関東SS","九州SS","2次店","その他","退職"]
  end
end 