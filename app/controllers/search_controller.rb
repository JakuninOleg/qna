class SearchController < ApplicationController
  skip_authorization_check

  def index
    query = params[:query]
    resource = params[:resource]

    @results = Search.find(query, resource)
  end
end
