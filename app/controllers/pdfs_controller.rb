class PdfsController < ApplicationController
  def index
    @fpath = Rails.root.join('pdf/')
  end

  def show
    @fpath = Rails.root.join("pdf/#{params[:id]}.pdf")
    render file: @fpath
  end
end
