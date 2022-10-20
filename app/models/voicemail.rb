class Voicemail < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
self.primary_key = :uniqueid
belongs_to :exten

end
