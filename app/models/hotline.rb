class Hotline < ApplicationRecord
belongs_to :account
has_many :agents, dependent: :destroy

validates_uniqueness_of :title, scope: :account_id

enum strategy: {
    rrmemory: "rrmemory",
    roundrobin: "roundrobin",
    ringall: "ringall",
    random: "random",
    leastrecent: "leastrecent",
    fewestcalls: "fewestcalls"
}
end
