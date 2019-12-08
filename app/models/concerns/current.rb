# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :post
  attribute :district
  attribute :department
  attribute :post_user
  attribute :post_visitor
end