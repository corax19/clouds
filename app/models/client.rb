class Client < ApplicationRecord
belongs_to :account

has_many :notes, dependent: :destroy
end
