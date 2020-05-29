module UsersHelper
  def role_checkboxes(roles)
    checkboxes = []
    if @current_user.is_super?
      role_array = ["super","admin","trustee","member"]
    elsif @current_user.is_admin?
      role_array = ["admin","trustee","member"]
    end

    role_array.each do |i|
      checkboxes << [i,roles.include?(i)]
    end
    checkboxes
  end

  def deny_access(msg = nil)
    msg ||= "Please sign in to access this page."
    flash[:notice] ||= msg
    respond_to do |format|
      format.html {
        redirect_to login_url
      }
      format.js {
        render 'sessions/redirect_to_login', :layout=>false
      }
    end
  end 
  
  def sign_out
    session[:user_id] = nil
    reset_session
    Current.user = nil
    Current.post = nil
    Current.district = nil
    Current.department = nil
    Current.post_user = nil

  end

end
