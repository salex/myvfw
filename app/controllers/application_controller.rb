class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  # after_action :verify_authorized, only: [:new,:create,:edit,:update,:destroy]


  before_action :current_user
  # before_action :current_post
  def cant_do_that
    puts "cant_do_that"
    redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
  end
  helper_method :cant_do_that

  def current_user
    # reset_session
    # p "begin what is in current post_user: #{Current.post_user} dist: #{Current.district} post: #{Current.post} dept: #{Current.department}"

    @current_user ||= User.find_by(id:session[:user_id]) if session[:user_id]
    Current.user = @current_user
    if @current_user.present?
      Current.post_user = false
      case @current_user.user_type

      when 'PostUser'
        Current.post = current_post
        Current.district = nil
        Current.department = nil
        Current.post_user = Current.post.numb == Current.user.post if Current.post.present? && Current.user.present?
      when 'DistrictUser'
        Current.district = @current_user.district
        Current.department = nil
        Current.post = current_post if session[:visitor].present?
        Current.post_visitor = session[:visitor].present?
      when 'DepartmentUser'
        Current.post = current_post if session[:visitor].present?
        Current.district = nil
        Current.department = @current_user.department
        Current.post_visitor = session[:visitor].present?

      end
    end
    if @current_user.blank? && session[:visitor] && session[:post_id].present?
      current_post
      Current.post_visitor = true
    end 
     # p "end what is in current post_user: #{Current.post_user} dist: #{Current.district} post: #{Current.post} dept: #{Current.department}"

    @current_user
  end
  helper_method :current_user

  def current_post
    @current_post ||= Post.find_by(id:session[:post_id]) if session[:post_id]
    Current.post =@current_post
    @current_post
  end
  helper_method :current_post

  def require_login
    if current_user.nil? 
      redirect_to root_url, alert: "I'm sorry. I can't do that."
    end
  end
  helper_method :require_login

  def require_trustee
    if current_user.blank? || !current_user.is_trustee?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_trustee

  def require_admin
    if current_user.blank? || !current_user.is_admin?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_admin

  def require_super
    if current_user.blank? || !current_user.is_super?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_super

  def require_member
    if current_user.blank? || !current_user.is_member?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_member

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end





end
