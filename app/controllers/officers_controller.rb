class OfficersController < ApplicationController
  before_action :set_officer, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new,:create,:edit,:update,:destroy]

  # GET /officers
  # GET /officers.json
  def index
    if params[:all].present?
      @officers = Current.post.officers.all.order(:seq)
    else
      @officers = Current.post.officers.where(current: :true).order(:seq)
    end
  end

  # GET /officers/1
  # GET /officers/1.json
  def show
  end

  # GET /officers/new
  def new
    @officer = Current.post.officers.new
  end

  # GET /officers/1/edit
  def edit
  end

  # POST /officers
  # POST /officers.json
  def create
    @officer = Current.post.officers.new(officer_params)

    respond_to do |format|
      if @officer.save
        format.html { redirect_to @officer, notice: 'Officer was successfully created.' }
        format.json { render :show, status: :created, location: @officer }
      else
        format.html { render :new }
        format.json { render json: @officer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /officers/1
  # PATCH/PUT /officers/1.json
  def update
    respond_to do |format|
      if @officer.update(officer_params)
        format.html { redirect_to @officer, notice: 'Officer was successfully updated.' }
        format.json { render :show, status: :ok, location: @officer }
      else
        format.html { render :edit }
        format.json { render json: @officer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /officers/1
  # DELETE /officers/1.json
  def destroy
    @officer.destroy
    respond_to do |format|
      format.html { redirect_to officers_url, notice: 'Officer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_officer
      @officer = Current.post.officers.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def officer_params
      params.require(:officer).permit(:member_id, :position, :from_date, :to_date, :current)
    end
end
