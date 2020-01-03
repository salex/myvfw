class TrusteeAuditsController < ApplicationController
  before_action :require_admin, only: [:new,:create,:edit,:update,:destroy,:get_audit]
  before_action :require_post

  # before_action :set_audit, only: [:show, :edit, :update, :destroy]



  def index
    @audits = policy_scope(TrusteeAudit).order(:key).reverse_order

  end

  def show
    audit = Current.post.trustee_audits.find(params[:id])
    @audit = audit.hash_data
  end

  def new
    audit = Current.post.trustee_audits.find(params[:id])
    render template:'trustee_audits/get_audit'
  end

  def create
  end

  def edit
    @audit = Current.post.trustee_audits.find(params[:id])
    render template:'trustee_audits/get_audit'
  end

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
    @audit_obj = GetAudit.new(params[:date])
    pdf = PdfAudit.new(@audit_obj.audit.report)
    send_data pdf.render, filename: "trustee_audit",
      type: "application/pdf",
      disposition: "inline"
  end


  def update_audit
    pp = audit_params
    audit = pp[:audit]
    stash = TrusteeAudit.find_by(key:audit[:keyname])
    if stash.present?
      ahash = []
      ohash = []
      audit[:accounts].each{|k,v| ahash << v}
      audit[:operations].each{|k,v| ohash << v}
      audit[:accounts] = ahash
      audit[:operations] = ohash
      stash.hash_data = audit.to_o
      stash.save
    end
    redirect_to reports_path, notice: "Audit report has been saved"
    # pp = audit_params
    # audit = pp[:audit]
    # # puts audit
    # # render plain: audit
    # if TrusteeAudit.save(audit)
    #   redirect_to root_path, notice: "Audit report has been saved"
    # end
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
