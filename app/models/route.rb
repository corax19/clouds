class Route < ApplicationRecord
belongs_to :account
belongs_to :sip

has_many :steps, dependent: :destroy
end
