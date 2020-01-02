class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:index,:show,:search,:logout,:list,:summary,:audit_summary,:print,:community_service, :trustee_audit_pdf]

  # before_action :require_trustee

  # GET /reports
  # GET /reports.json
  def community_service
    @summary,@totals,@range = Current.post.reports.report_summary(params[:rdate])
    render template:'reports/post_summary'

    # @reports = Report.all
    # render template:'reports/index'
  end

  def list
    @reports = Current.post.reports.where(date:Report.report_range(params[:rdate])).order(:date).reverse
    render template:'reports/_list'
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    render template:'reports/show'
  end

  # GET /reports/new
  def new
    type_report,area = params[:kind].split('.')
    @report = Current.post.reports.new(type_report:type_report,area:area)
    render template:'reports/new'

  end

  # GET /reports/1/edit
  def edit
    render template:'reports/edit'

  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Current.post.reports.new(report_params)
    if params[:kind].present?
      kind = params[:kind].split('.')
      @report.type_report = kind[0]
      @report.area = kind[1]
    end

    respond_to do |format|
      if @report.save
        format.html { redirect_to report_path(@report), notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    if params[:kind].present?
      kind = params[:kind].split('.')
      @report.type_report = kind[0]
      @report.area = kind[1]
    end
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to report_path(@report), notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to community_service_reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def summary
    @summary,@totals,@range = Current.post.reports.report_summary(params[:rdate])
    render template:'reports/post_summary'
    # respond_to do |format|
    #   format.html { render template:'reports/post_summary' }
    #   format.js {render template:'reports/programs'}
    #  end
  end

  def audit_summary
    @summary,@totals,@range = Current.post.reports.audit_summary(params[:audit]) # 0 to 3
    render template:'reports/post_summary'
    # respond_to do |format|
    #   format.html { render template:'reports/post_summary' }
    #   format.js {render template:'reports/programs'}
    #  end
  end

  # def trustee_audit
  #   @audit = TrusteeAudit.new(params[:date]).config
  # end

  # def trustee_audit_pdf
  #   pdf = PdfAudit.new(params[:date])
  #   send_data pdf.render, filename: "trustee_audit",
  #     type: "application/pdf",
  #     disposition: "inline"
  # end


  # def update_audit
  #   pp = audit_params
  #   audit = pp[:audit]
  #   # puts audit
  #   # render plain: audit
  #   if TrusteeAudit.save(audit)
  #     redirect_to root_path, notice: "Audit report has been saved"
  #   end
  # end



  def menu
    render template:'reports/menu'
  end

  def print
    # @summary,@totals = Report.report_summary(params[:rdate])
    # range = Report.report_range(params[:rdate])
    # @reports = Report.where(date:range).order(:date).reverse
    @results = Current.post.reports.quarter_summary(params[:rdate])
    @summary,@totals,@range = Current.post.reports.report_summary(params[:rdate])

    render template:'reports/print', layout: 'print'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Current.post.reports.find(params[:id])
    end
    def audit_params
      params.permit!.to_h
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:audit,:type_report, :date, :details, :area, :remarks, :volunteers, :hours_each, :miles_each, :expenses, :total_hours, :total_miles, :updated_by)
    end
end
