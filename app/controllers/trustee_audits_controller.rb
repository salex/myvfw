class TrusteeAuditsController < ApplicationController
  before_action :require_admin, except: :pdf
  before_action :require_post

  # before_action :set_audit, only: [:show, :edit, :update, :destroy]



  def index
    if Current.post_user
      @audits = policy_scope(TrusteeAudit).order(:key).reverse_order
    else
      cant_do_that
    end

  end

  def show
    audit = Current.post.trustee_audits.find(params[:id])
    @audit = audit
  end

  def edit
    audit = Current.post.trustee_audits.find(params[:id])
    @audit = audit
  end

  def new
    @audit = TrusteeAudit.new_audit
    if @audit.save
      render template:'trustee_audits/edit'
    else
      redirect_to trustee_audits_path, alert:'screwed up'
    end
  end

  def create

  end

  # def edit
  #   @audit = Current.post.trustee_audits.find(params[:id])
  #   render template:'trustee_audits/get_audit'
  # end

  # def update
  #   render plain: params
  # end

  def destroy
    @audit = Current.post.trustee_audits.find(params[:id])
    @audit.destroy
    respond_to do |format|
      format.html { redirect_to trustee_audits_path, notice: 'Audit was successfully destroyed.' }
      format.json { head :no_content }
    end


  end

  def get_audit
    @audit_obj = GetAudit.new(params[:date])
    if @audit_obj.error.present?
      redirect_to reports_path, alert: @audit_obj.error
    end
  end

  def pdf
    audit = Current.post.trustee_audits.find(params[:id])
    @audit = audit.audit

    # @audit_obj = GetAudit.new(params[:date])
    pdf = PdfAudit.new(@audit)
    send_data pdf.render, filename: "trustee_audit",
      type: "application/pdf",
      disposition: "inline"
  end


  def update
    audit_params = params[:trustee_audit][:audit]
    # puts "DAPARAMS #{audit.keys}"

    # stash = TrusteeAudit.find_by(key:audit[:keyname])
    audit = TrusteeAudit.find(params[:id])

    audit.hash_data = audit.params_to_hash(audit_params).to_json
    # puts stash.inspect
    # render plain: audit_params
    # if stash.present?
    #   stash.text_data = audit.permit!.to_h
    #   stash.save
    # end

    audit.save
    redirect_to trustee_audits_path, notice: "Audit report has been saved"
  end

  private

    def audit_params
      params.permit!.to_h
    end

    def require_post
      @post = Current.post
      require_member if @post.blank?
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def trustee_audit_params
      params.require(:trustee_audit).permit(:post_id,:type,:key, :date, :hash_data, :array_data,:text_data)
    end

end
