class AttachmentsController < ApplicationController
  authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
  end
end
