class AddMaybeToEventAttendees < ActiveRecord::Migration
  def change
    add_column :event_attendees, :reply, :integer
  end
end