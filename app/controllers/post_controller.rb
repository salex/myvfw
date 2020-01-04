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
    calendar = Current.post.post_calendar
    if calendar.blank?
      calendar = Current.post.build_calendar
    end
    if calendar.present?
      @events = Ical.new(params).upcoming_events
    else
      redirect_to root_path, notice: "Post Calendar not found, see about to add calendars"
    end
  end
  def month_calendar
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @ical = Ical.new(params)
    first = @date.beginning_of_month.beginning_of_week(:sunday)
    last = @date.end_of_month.end_of_week(:sunday)
    @events = @ical.find_events(first,last,params)
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

#https://p03-calendars.icloud.com/published/2/yDA7SN0imoKyRwRczElJRZZI9onlqUtZCftvEpV4cGtOJUv5InLGSj9y1FxR4x6ea1ME5at0r-5aP6gF__sXR2g3l3PFwn93tRZoV22HyG8
# webcal://p44-caldav.icloud.com/published/2/NDg3NjQ2MjQ4NzY0NjI0OEjYH9s2TxLD7vDgbdxkRpuKrgDocoMJw3KBXikypUzvN4fu55d4CdJ0kyQea2RMyOydOvHczC9IspyAUP4g1pc