class Host < ApplicationRecord
  has_many :ports, dependent: :destroy

  accepts_nested_attributes_for :ports

  validates :hostname, presence: true, uniqueness: true
  validates :connect, presence: true
end
