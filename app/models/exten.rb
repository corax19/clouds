class Exten < ApplicationRecord
has_one :voicemail, dependent: :destroy

validates_uniqueness_of :exten, scope: :account_id

  belongs_to :account
  belongs_to :sip


end
