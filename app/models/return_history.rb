class ReturnHistory < ApplicationRecord
  belongs_to :user 
  belongs_to :stock , optional: true
end
