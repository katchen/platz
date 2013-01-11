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
    event = Event.find(params[:event_id])
    user = User.find(params[:user_id])
    event.attendees << user
    reply = params[:reply].to_i
    if event.save
      
      if reply == 0
        user.set_going(event)
        notice = "I'll be there!"
      elsif reply == 1
        user.set_not_going(event)
        notice = "Missing out"
      elsif reply == 2
        user.set_maybe_going(event)
        notice = "I don't know yet.."
      end
    else
      notice = "Failed to save your reply"
    end
    redirect_to events_url, :notice => notice
  end
end

def rsvpyes
  EventAttendee.create(:user => current_user, :event =>params[:event_id]);
end
