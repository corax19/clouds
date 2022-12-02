class Account < ApplicationRecord
has_many :users, dependent: :destroy
has_many :sips, dependent: :destroy
has_many :sounds, dependent: :destroy
has_many :extens, dependent: :destroy
has_many :hotlines, dependent: :destroy
has_many :routes, dependent: :destroy
has_many :steps, dependent: :destroy
has_many :mohs, dependent: :destroy

has_many :messages, dependent: :destroy
has_many :categories, dependent: :destroy
has_many :comments, dependent: :destroy

has_many :clients, dependent: :destroy

mount_uploader :image, SoundUploader

end
