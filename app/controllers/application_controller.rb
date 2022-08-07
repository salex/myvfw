class ApplicationController < ActionController::Base
  # set_current_tenant_through_filter
  include UsersHelper
  before_action :current_user 
  # before_action :current_book

  def require_book
    if Current.user.blank?
      deny_access
    else
      redirect_to(books_path, alert:'Current Book is required') if Current.book.blank?
    end
  end
  helper_method :require_book

  def current_user
    @current_user ||= User.find_by(id:session[:user_id]) if session[:user_id]
    Current.user = @current_user
    if Current.user
      Current.client = Current.user.client
      current_book
    end
  end
  helper_method :current_user

  def current_book
    if session[:book_id].present?
      Current.book = Current.client.books.find_by(id:session['book_id'])
    end
  end

end
