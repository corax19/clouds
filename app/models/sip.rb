class Sip < ApplicationRecord
belongs_to :account
has_many :extens
has_many :routes

  validates :sipid, presence: true
  validates :secret, presence: true
  validates :host, presence: true
  validates :number, presence: true

end
