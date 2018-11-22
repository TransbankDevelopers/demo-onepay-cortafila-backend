class ShoppingCart < ApplicationRecord
  belongs_to :device
  has_many :items
end
