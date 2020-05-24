class FormsController < ApplicationController
  def bartender
    render 'posbartender', layout: 'print_plain'
  end

  def cash_report
    pdf = CashReport.new(view_context)
    send_data pdf.render, filename: "CashReport-#{params[:id]}", 
      type: "application/pdf",
      disposition: "inline"
   end

end
