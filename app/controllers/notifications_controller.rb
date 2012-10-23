class NotificationsController < ApplicationController
  layout :nil

  def show
    @notification = Notification.find(params[:id])
  end

  def index
    @notifications = Notification.all
  end
end
