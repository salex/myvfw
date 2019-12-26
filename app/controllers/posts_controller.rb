class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_super, only: [:index,:new,:create,:destroy]
  before_action :require_admin, only: [:edit,:update]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order(:numb)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def visit
    set_post
    Current.post = @post
    Current.post_visitor =  session[:visitor] =true 
    session[:post_id] =Current.post.id
    @greeting = @post.markups.find_by(category:'greeting')
    @home = @post.markups.where(category:'home',active:true).order(:updated_at).reverse_order
    @slim = @post.markups.find_by(category:'slim')
    @alerts = @post.markups.where(category:%w{alert warning success},active:true).order(:updated_at).reverse_order


    render template: 'home/post'
  end

  def exit_visit
    session.delete(:post_id)
    session.delete(:visitor)
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name,:numb,:address,:city,:state,:phone,:txt,:email,:web,:zip,:fax)
    end
end
