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

  def self.get_active(categories)
    categories = [categories] unless categories.class == Array
    markups = Current.post.markups.where(active:true,category:categories).order(:updated_at).reverse_order
    today = Date.today 
    notexpired = markups.where(Markup.arel_table[:expires].eq(nil).or Markup.arel_table[:expires].gteq(today))
  end

end
