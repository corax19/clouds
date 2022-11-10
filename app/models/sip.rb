class Sip < ApplicationRecord
belongs_to :account
has_many :extens
has_many :routes, dependent: :destroy

validates_uniqueness_of :sipid, scope: :account_id
validates_uniqueness_of :number, scope: :account_id

  validates :sipid, presence: true
  validates :secret, presence: true
  validates :host, presence: true
  validates :number, presence: true

end
