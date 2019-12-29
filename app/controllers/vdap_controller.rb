class VdapController < ApplicationController
  layout 'plain'
  def home
  end

  def about
  end

  def resources
    @markup = Current.post.markups.find_by(id:params[:id])
    if @markup
      render template:'markups/plain', layout: 'plain'
    else
      cant_do_that
    end
  end
end
