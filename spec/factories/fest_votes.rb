FactoryBot.define do

  factory :fest_vote , class: FestVote do
    id { 1 }
    fest_id { 1 }
    user_id { 1 }
    selection {"a"}
  end

end