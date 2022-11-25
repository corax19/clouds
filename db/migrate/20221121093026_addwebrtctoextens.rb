class Addwebrtctoextens < ActiveRecord::Migration[7.0]
  def change
  add_column :extens, :webrtc, :string, :default => 'No'
  end
end
