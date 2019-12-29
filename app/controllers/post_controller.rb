class PostController < ApplicationController
  before_action :require_post
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

  def edit
    @post = Current.post
    render template:'posts/edit'
  end

  def members
  end

  def map
    @map = Current.post.markups.find_by(title:'map')
  end

  def radar
    @radar = Current.post.markups.find_by(title:'radar')
  end

  def news
  end

  def links
    @markups =  Current.post.markups.where(category:'links',active:true).order(:date).reverse_order

  end

  def articles
    @markups =  Current.post.markups.where(category:'articles',active:true).order(:date).reverse_order
  end

  def minutes
    @markups =  Current.post.markups.where(category:'minutes',active:true).order(:date).reverse_order
  end

  def calendar
    calendar = Current.post.markups.find_by(category:'kiosk',title:'calendar')
    if calendar.present?
      @events = Ical.new(params[:refresh]).upcoming_events
    else
      redirect_to root_path, notice: "Calendars were not found in markup kiosk/calendar"
    end
  end

  def contact
    redirect_to root_path, alert: "Post/Officer Contact is under construction"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def require_post
      @post = Current.post
      require_member if @post.blank?
    end


end
