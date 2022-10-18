class MohEntry < ApplicationRecord
  belongs_to :account
  belongs_to :moh
  belongs_to :sound


end
