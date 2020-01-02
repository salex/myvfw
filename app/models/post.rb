class Post < ApplicationRecord
  has_many :members
  has_many :markups
  has_many :reports
  has_many :officers
  has_many :trustee_audits

  def self.districts
    dist = User.where.not(district:nil).pluck(:district).uniq.sort
  end

  def self.posts
    dist = User.where.not(numb:nil).pluck(:numb).uniq.sort
  end

  def self.district_posts
    dist_posts = {}
    Post.districts.each do |d|

      dist_posts[d] = Post.where(district_id:d).order(:numb).pluck(:numb,:id).to_h
    end
    dist_posts
  end

end
