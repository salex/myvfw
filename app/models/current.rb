# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :client
  attribute :user
  attribute :book
  attribute :account
end