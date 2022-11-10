class Moh < ApplicationRecord
belongs_to :account

validates_uniqueness_of :name, scope: :account_id

has_many :moh_entries, dependent: :destroy

end
