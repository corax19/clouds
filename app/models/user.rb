class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
validates_uniqueness_of :username
#, scope: :account_id
validates_uniqueness_of :email

belongs_to :account

mount_uploader :image, SoundUploader

  validates :username, presence: true
  validates :email, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
