class AboutsController < ApplicationController
  def index
    if params[:topic].present?
      render turbo_stream: turbo_stream.replace(
        'topic', partial:params[:topic] )
    end
  end

end