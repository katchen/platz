class EventsController < ApplicationController
  before_filter :require_login

  def index
    @events = current_user.events
    @created_events = current_user.created_events
    @all_events= Event.all
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(params[:event])
    @event.creator = current_user
    if @event.save
      redirect_to user_events_url, :notice => "Event Created!"
    else
      render "new"
    end
  end

  def edit
    @event = current_user.created_events.find(params[:id])
  end

  def update
    @event = current_user.created_events.find(params[:id]) 
    if @event.update_attributes(params[:event])
      redirect_to user_events_url, :notice => "Event Updated!"
    else
      render "edit"
    end
  end

  def show
    user = User.find(params[:user_id])
    @event = user.created_events.find(params[:id])
  end

  def destroy
    @event = current_user.created_events.find(params[:id])
    if @event.destroy
      notice = "Event Destroyed!"
    else
      notice = "Event could not be Destroyed!"
    end
    redirect_to user_events_url, :notice => notice
  end
  

  def attend
    @event = current_user.created_events.find(params[:event_id])
    user = User.find(params[:user_id])
    @event.attendees << user
    if @event.save
      redirect_to user_events_url, :notice => "Attending Event!"
    else
      render "show"
    end
  end
end
