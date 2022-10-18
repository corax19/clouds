class Moh < ApplicationRecord
belongs_to :account


has_many :mohentries, dependent: :destroy

end
