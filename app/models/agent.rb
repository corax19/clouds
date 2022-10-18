class Agent < ApplicationRecord
  belongs_to :account
  belongs_to :hotline
  belongs_to :exten
end
