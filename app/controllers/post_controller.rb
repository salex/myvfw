class PostController < ApplicationController
  # def officers
  #   if current_user.present?

  #     if params[:all].present?
  #       @officers = Officer.all.order(:seq)
  #     else
  #       @officers = Officer.where(current: :true).order(:seq)
  #     end
  #     render template:'officers/index'
  #   else
  #     @officers = Officer.current_officers
  #     render template:'post/officers'
  #   end
  # end

  def members
  end

  def news
  end

  def links
    @markups =  Markup.where(category:'links',active:true).order(:date).reverse_order

  end

  def articles
    @markups =  Markup.where(category:'articles',active:true).order(:date).reverse_order
  end

  def minutes
    @markups =  Markup.where(category:'minutes',active:true).order(:date).reverse_order
  end

  def calendar
    @events = Ical.new(params[:refresh]).upcoming_events
  end

  def contact
    redirect_to root_path, alert: "Post/Officer Contact is under construction"
  end

end
