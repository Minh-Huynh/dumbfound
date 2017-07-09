class SitemapsController < ApplicationController
  layout nil
  def index
    headers['Content-Type'] = 'application/xml'
    respond_to :xml
  end

end


