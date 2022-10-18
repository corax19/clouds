class AddOtherColumnsTo < ActiveRecord::Migration[7.0]
  def change
  add_column :hotlines, :musiconhold, :string
  add_column :hotlines, :announce, :string
  add_column :hotlines, :context, :string
  add_column :hotlines, :monitor_join, :integer
  add_column :hotlines, :monitor_format, :string
  add_column :hotlines, :queue_youarenext, :string
  add_column :hotlines, :queue_thereare, :string
  add_column :hotlines, :queue_callswaiting, :string
  add_column :hotlines, :queue_holdtime, :string
  add_column :hotlines, :queue_minutes, :string
  add_column :hotlines, :queue_seconds, :string
  add_column :hotlines, :queue_lessthan, :string
  add_column :hotlines, :queue_thankyou, :string
  add_column :hotlines, :queue_reporthold, :string
  add_column :hotlines, :announce_frequency, :integer
  add_column :hotlines, :announce_round_seconds, :integer
  add_column :hotlines, :announce_holdtime, :string
  add_column :hotlines, :servicelevel, :integer
  add_column :hotlines, :joinempty, :string
  add_column :hotlines, :leavewhenempty, :string
  add_column :hotlines, :eventmemberstatus, :string
  add_column :hotlines, :eventwhencalled, :string
  add_column :hotlines, :reportholdtime, :integer
  add_column :hotlines, :memberdelay, :integer
  add_column :hotlines, :weight, :integer
  add_column :hotlines, :timeoutrestart, :integer
  add_column :hotlines, :periodic_announce, :string
  add_column :hotlines, :periodic_announce_frequency, :integer
  add_column :hotlines, :ringinuse, :integer
  add_column :hotlines, :setinterfacevar, :string
  end
end
