module Rated
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: %i[vote_up vote_down reset_vote]
    before_action :vote_access, only: %i[vote_up vote_down]
  end

  def vote_up
    @resource.vote_up(current_user)
    render_json_details
  end

  def vote_down
    @resource.vote_down(current_user)
    render_json_details
  end

  def reset_vote
    if @resource.voted_by?(current_user)
      @resource.reset_vote(current_user)

      render_json_details
    else
      head :unprocessable_entity
    end
  end

  private

  def find_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def vote_access
    if @resource.voted_by?(current_user) || current_user.author_of?(@resource)
      head :unprocessable_entity
    end
  end

  def render_json_details
    render json: { rating: @resource.votes, klass: @resource.class.to_s, id: @resource.id }
  end
end
