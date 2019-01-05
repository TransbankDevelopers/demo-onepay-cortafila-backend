class Device < ApplicationRecord
  enum source: [:web, :android]
  has_many :shopping_carts
end
