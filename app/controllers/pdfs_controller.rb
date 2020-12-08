class PdfsController < ApplicationController
  def index
    @fpath = Rails.root.join('pdf/By-Laws.pdf')
    render file:@fpath
  end

  def show
    @fpath = Rails.root.join('pdf/By-Laws.pdf')
    render file: @fpath
  end
end
