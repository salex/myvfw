class TestController < ApplicationController
  def index
    @movies = Array.new(27) { |e| e = e + 1 }
  end

  def test
    session[:test_list] = {"1"=>'c',"2"=>'c',"3"=>'c',"4"=>'c',"5"=>'c',"6"=>'n',"7"=>'n',"8"=>'n',"9"=>'n',"10"=>'n'}
  end

  def clear
    id = params[:id]
    session[:test_list][id] = 'c'
  end

  def unclear
    id = params[:id]
    session[:test_list][id] = 'n'
  end

  def fire
    dir,id = params[:payload].split('|')
    session[:test_list][id] = dir
    render partial:'test/fire'
  end

  def link
    dir,id = params[:payload].split('|')
    session[:test_list][id] = dir
    render partial:'test/link'
    # respond_to do |format|
    #   format.html {render partial:'test/link'}
    #   format.js
    # end
  end

end
