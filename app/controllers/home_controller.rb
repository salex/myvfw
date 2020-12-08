class HomeController < ApplicationController
  def index
    # session[:user_id] = 20
    # session[:post_id] = 19
    # p "what is current dist #{Current.district} post #{Current.post} dept #{Current.department}"
    if @current_post.present?
      @post = Current.post
      @greeting = @post.markups.find_by(category:'greeting') # greeting never expires and only first
      @home = Markup.get_active(['home'])
      # @slim = @post.markups.find_by(category:'slim')
      @alerts = Markup.get_active(%w{alert warning success info})
      if @greeting.blank? && !session[:visitor]
        render template: 'home/index'
      else
        render template: 'home/post'
      end
    elsif Current.district.present?
      @posts = Post.where(district_id:@current_user.district,department:@current_user.department)
      render template: 'home/district'
    elsif Current.department.present?
      render template: 'home/department'

    else
      render template: 'about/about'
    end
  end

  def welcome
    render template:'home/welcome'
  end
  
  def hello
  end

  def redirect
    path = params[:path]
    if path.include?('post')
      post = Post.find_by(numb:path.delete('post').to_i)
      # p "POST #{post.inspect}"
      if post.present?
        session[:post_id] = post.id
        session[:visitor] = true
        # session[:user_id].delete if session[:user_id].present?
        current_post
        @post = Current.post
        @greeting = @post.markups.find_by(category:'greeting')
        @home = @post.markups.where(category:'home',active:true).order(:updated_at).reverse_order
        @alerts = @post.markups.where(category:%w{alert warning success info},active:true).order(:updated_at).reverse_order
        redirect_to root_path, notice: "Visiting Post #{@post.numb}"
      else
        redirect_to root_path, notice: "Sorry, Post #{post} could not be found"
      end
    else
      cant_do_that
    end
  end

end
