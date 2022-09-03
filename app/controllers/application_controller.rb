class ApplicationController < ActionController::Base
  set_current_tenant_through_filter  ### for acts_as-tenant
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

  def require_super
    if Current.user.blank? || !Current.user.is_super?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_super

  def require_admin
    if current_user.blank? || !current_user.is_admin?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_admin
  
  def require_trustee
    if current_user.blank? || !current_user.is_trustee?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_trustee

  def current_user
    @current_user ||= User.find_by(id:session[:user_id]) if session[:user_id]
    Current.user = @current_user
    if Current.user
      if session[:client_id].present?
        Current.client = Client.find(session[:client_id])
      else
        Current.client = Current.user.client
      end
      set_current_tenant(Current.client)### for acts_as-tenant
      current_book
    end
  end
  helper_method :current_user

  def current_book
    if session[:book_id].present?
      Current.book = Current.client.books.find_by(id:session['book_id'])
    end
  end

  def latest_ofxes_path
    if session[:latest_ofx_path].present?
      bank_statement_path(session[:latest_ofx_path])
    else
      bs = Current.book.bank_statements.last 
      bank_statement_path(bs.id)
    end
  end


end
