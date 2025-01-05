class Company < ApplicationRecord
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses

  validates :name, presence: true
  validates :registration_number, presence: true, uniqueness: true
end
