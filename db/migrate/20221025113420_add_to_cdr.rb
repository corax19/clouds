class AddToCdr < ActiveRecord::Migration[7.0]
  def change
    add_column :cdrs, :accountcode, :string
    add_column :cdrs, :src, :string
    add_column :cdrs, :dst, :string
    add_column :cdrs, :dcontext, :string
    add_column :cdrs, :clid, :string
    add_column :cdrs, :channel, :string
    add_column :cdrs, :dstchannel, :string
    add_column :cdrs, :lastapp, :string
    add_column :cdrs, :lastdata, :string
    add_column :cdrs, :start, :datetime
    add_column :cdrs, :answer, :datetime
    add_column :cdrs, :end, :datetime
    add_column :cdrs, :duration, :integer
    add_column :cdrs, :billsec, :integer
    add_column :cdrs, :disposition, :string
    add_column :cdrs, :amaflags, :string
    add_column :cdrs, :userfield, :string
    add_column :cdrs, :uniqueid, :string
    add_column :cdrs, :linkedid, :string
    add_column :cdrs, :peeraccount, :string
    add_column :cdrs, :sequence, :integer


  end
end
