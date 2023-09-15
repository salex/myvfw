class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:index,:search,:logout]
  before_action :require_admin, only: [:new,:create,:edit,:update,:destroy,:import,:import_form]


  protect_from_forgery except: :search
  # GET /members
  # GET /members.json
  def index
    @members = Member.active #policy_scope(Member)
    @memstats = Member.memstats
  end

  def filter
    if params[:limit].present?
      @members = Member.limit(params[:limit])
      if params[:phone]
        render turbo_stream: turbo_stream.replace(
          'members', partial: 'members/list')
      else
        render turbo_stream: turbo_stream.replace(
          'members', partial: 'members/filtered')
      end
    else
      redirect_to members_path
    end
  end

  def search
    if params[:name].present?
      @members = Member.search(params)
      render turbo_stream: turbo_stream.replace(
        'members', partial: 'members/filtered')
    else
      redirect_to members_path,alert:'Invalid search parameters'
    end


  # def search
  #   puts "DDDDD got to search #{params}"
  #   @members = Member.search(params)
  #   puts "DDDDD #{@members.count}"

  #   respond_to do |format|
  #     format.html {render text:"I'm sorry, I can't do that.", layout:true}
  #     format.js 
  #   end
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
    @email,@address,@all_addresses = Current.post.members.contact_addresses(params[:status])
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

  def test_email
    set_member
    send_email(@member)
    redirect_to members_url, notice: 'Member was sent an email.'
    # render plain: @member.inspect
  end

  def send_mailer
    members = Member.has_email?
    members.each do |m|
      send_email(m)
    end
    redirect_to members_url, notice: "Members email was sent to #{members.size} members."

  end

  def test_mail

    # member =  Member.is_deliverable? 
    members = Member.active.where(id:[2,7])
    err = true
    pdf = LetterMailer.new(members,err)
    send_data pdf.render, filename: "letter}",
      type: "application/pdf",
      disposition: "inline"
  end

  def get_mailable
    members = Member.is_deliverable?
    pdf = LetterMailer.new(members)
    send_data pdf.render, filename: "letter}",
      type: "application/pdf",
      disposition: "inline"
  end

  private

    def send_email(member)
      MembersMailer.with(member: member).members_email.deliver_later
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Current.post.members.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:vfw_id, :first_name, :mi, :last_name, :full_name, :phone, :address, :city, :state, :zip, :status, :email, :type_pay, :pay_year, :pay_status, :pay_date, :country, :undeliverable, :paid_thru, :days_remaining, :last_status, :served, :alt_phone)
    end
end
