class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_presence_of :email

  has_many :created_events, :class_name => "Event", :foreign_key => :creator_id
  has_many :event_attendees
  has_many :events, :through => :event_attendees

  def set_going(event)
    event_attendee = event_attendees.find_by_event_id(event.id)
    event_attendee.update_attributes(:reply => 0)
  end
  
  def set_not_going(event)
    event_attendee = event_attendees.find_by_event_id(event.id)
    event_attendee.update_attributes(:reply => 1)
  end
  
  def set_maybe_going(event)
    event_attendee = event_attendees.find_by_event_id(event.id)
    event_attendee.update_attributes(:reply => 2)
  end
  
  def reply(event)
    event_attendee = event_attendees.find_by_event_id(event.id)
    return nil if event_attendee.nil?
    event_attendee.reply
  end
end
