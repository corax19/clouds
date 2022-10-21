class Sound < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

belongs_to :account

validates_uniqueness_of :name, scope: :account_id
#has_many :mohentries, dependent: :destroy

mount_uploader :audio, AudioUploader

end
