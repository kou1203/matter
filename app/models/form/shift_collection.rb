class Form::ShiftCollection < Form::Base
  FORM_COUNT = 31
  attr_accessor :shifts

  def initialize(attributes = {})
    super attributes 
    self.shifts = FORM_COUNT.times.map { Shift.new() } unless self.shifts.present?
  end

  def shifts_attributes=(attributes)
    self.shifts = attributes.map { |_, v| Shift.new(v) }
  end

  def save
    Shift.transaction do 
      self.shifts.map do |shift|
        if shift.availability
          shift.save
        end 
      end
    end 
    return true 
  rescue => e
    return false
  end 
end 