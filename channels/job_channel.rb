class JobChannel < ApplicationCable::Channel
  def subscribed
  	stream_from "job_channel_user_#{current_user.id}_#{params[:room]}"
  end
end
