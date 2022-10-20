class Exten < ApplicationRecord
has_one :voicemail, dependent: :destroy

  belongs_to :account
  belongs_to :sip


end
