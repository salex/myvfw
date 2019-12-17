class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:index,:show,:search,:logout]
  before_action :require_admin, only: [:new,:create,:edit,:update,:destroy,:import,:import_form]


  protect_from_forgery except: :search
  # GET /members
  # GET /members.json
  def index
    if params[:limit].present?
      @members = Member.limit(params[:limit])
    else
      @members = Member.active #policy_scope(Member)
    end
    @memstats = Member.memstats
  end

  def search
    puts "DDDDD got to search #{params}"
    @members = Member.search(params)
    puts "DDDDD #{@members.count}"

    respond_to do |format|
      format.html {render text:"I'm sorry, I can't do that.", layout:true}
      format.js 
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Current.post.members.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    require_login
    if params[:member][:applicant].present?
      @applicant = params[:member].delete(:applicant)
    end
    @member = Current.post.members.new(member_params)
    
    respond_to do |format|
      if @member.status == 'Applicant'
        if @member.new_applicant(@applicant)
          format.html { redirect_to @member, notice: 'Applicant was successfully created.' }
          format.json { render :show, status: :created, location: @member }
        else
          format.html { redirect_to members_path, alert: "got errors #{@member.errors.inspect}" }

        end
      elsif @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def contacts
    @email,@address = Current.post.members.contact_addresses(params[:status])
  end
  
  def import
    Current.post.members.import(params[:file])
    redirect_to root_url, notice: "Members imported."
  end
  
  def import_form
  end

  def new_applicant
    require_login
    @member = Current.post.members.new(status:'Applicant')
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Current.post.members.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:vfw_id, :first_name, :mi, :last_name, :full_name, :phone, :address, :city, :state, :zip, :status, :email, :type_pay, :pay_year, :pay_status, :pay_date, :country, :paid_thru, :days_remaining, :last_status, :served, :alt_phone)
    end
end
