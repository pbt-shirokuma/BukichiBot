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
class FestVote < ApplicationRecord
    
  # Relation
  belongs_to :fest
  belongs_to :user

  # validation
  validates :fest_id, presence: true
  validates :user_id, presence: true
  validates :selection, inclusion: { in: ["a","b"] }
  validates :game_count, numericality: true
  validates :win_count, numericality: true
  validates :win_rate, numericality: true
  validate :vote_user_joined_active_fest, on: :create

  def selection_name
    selection == "a" ? fest.selection_a : fest.selection_b
  end
  
  private
  
  def vote_user_joined_active_fest
    errors.add(:user, "は既に開催されているフェスに参加しているため、参加できません。") if self.user.joined_active_fest.present?
  end

end
