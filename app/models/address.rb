class Address < ApplicationRecord
  belongs_to :company

  validates :street, :city, :postal_code, :country, presence: true
  validates :postal_code, allow_blank: true, length: { maximum: 20 }
end
