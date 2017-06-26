class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email
  validates_presence_of :phone_number
  before_save :format_phone_number

  def format_phone_number
    self.phone_number.gsub! /[^\d]/, ""
  end
end
