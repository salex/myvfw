class MarkupsController < ApplicationController
  before_action :set_markup, only: [:show, :edit, :update, :destroy, :display, :print, :plain]
  before_action :require_admin, only: [:new,:create,:edit,:update,:destroy]

  # GET /markups
  # GET /markups.json
  def index
    # @markups = Current.post.markups.filter(params[:filter])
    @markups = Markup.filter(params[:filter])
  end

  # GET /markups/1
  # GET /markups/1.json
  def show
  end

  # GET /markups/new
  def new
    @markup = Current.post.markups.new(date:Date.today)
  end

  # GET /markups/1/edit
  def edit

  end

  # POST /markups
  # POST /markups.json
  def create
    @markup = Current.post.markups.new(markup_params)

    respond_to do |format|
      if @markup.save
        format.html { redirect_to @markup, notice: 'Markup was successfully created.' }
        format.json { render :show, status: :created, location: @markup }
      else
        format.html { render :new }
        format.json { render json: @markup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /markups/1
  # PATCH/PUT /markups/1.json
  def update
    # p markup_params
    respond_to do |format|
      if @markup.update(markup_params)
        format.html { redirect_to @markup, notice: 'Markup was successfully updated.' }
        format.json { render :show, status: :ok, location: @markup }
      else
        format.html { render :edit }
        format.json { render json: @markup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /markups/1
  # DELETE /markups/1.json
  def destroy
    @markup.destroy
    respond_to do |format|
      format.html { redirect_to markups_url, notice: 'Markup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def display
  end

  def plain
    render template:'markups/plain', layout: 'plain'

  end

  def print
     render template:'markups/print', layout: 'print'
   end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_markup
      @markup = Markup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def markup_params
      params.require(:markup).permit(:user_id, :category, :title, :leadin, :content, :active, :date)
    end
end
