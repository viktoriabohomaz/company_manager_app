class Address < ApplicationRecord
  belongs_to :company
  validates :street, :city, :postal_code, :country, presence: true
end