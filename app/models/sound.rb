class Sound < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

belongs_to :account

has_many :mohentries, dependent: :destroy

mount_uploader :audio, AudioUploader

end
