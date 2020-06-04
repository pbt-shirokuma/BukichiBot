# == Schema Information
#
# Table name: fest_votes
#
#  id         :bigint           not null, primary key
#  game_count :integer          default(0)
#  selection  :string(255)      not null
#  win_count  :integer          default(0)
#  win_rate   :decimal(5, 2)    default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fest_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_fest_votes_on_fest_id                             (fest_id)
#  index_fest_votes_on_fest_id_and_user_id_and_created_at  (fest_id,user_id,created_at)
#  index_fest_votes_on_user_id                             (user_id)
#
FactoryBot.define do

  factory :fest_vote , class: FestVote do
    id { 1 }
    fest_id { 1 }
    user_id { 1 }
    selection {"a"}
  end

end
