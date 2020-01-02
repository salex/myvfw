class Stash < ApplicationRecord
  belongs_to :post
  # serialize :hash_data, Hash

  validates :key, uniqueness: true
end
