class Markup < ApplicationRecord
  # belongs_to :post
  belongs_to :user
  validates :date,:category, presence: true
  CATAGORIES = %w(greeting home articles news links kiosk minutes alert warning success info slim)

  def self.filter(filter)
    markups = Current.post.markups.all
    if filter.present?
      markups = markups.where(category:filter)
    end
    markups.order(:date).reverse_order
  end


  def permalink
    "/article/#{id}-#{title.parameterize}"
  end

end
