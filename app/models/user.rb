# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  account_token :string(255)
#  del_flg       :boolean          default(FALSE)
#  name          :string(255)      not null
#  status        :string(255)      default("00"), not null
#  talk_status   :string(255)      default("00")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  line_id       :string(255)
#
# Indexes
#
#  index_users_on_created_at  (created_at)
#
class User < ApplicationRecord

  # Relation
  has_many :fest, dependent: :destroy
  has_many :fest_votes, dependent: :destroy

  validates :name, presence: true


  before_create :set_account_token

  # status 定数
  STATUS = {
    :normal => "00",
    :fest => "10"
  }
  
  # talk_status 定数
  TALK_STATUS = {
    :normal => "00",
    :fest_vote => "10",
    :fest_record => "11"
  }

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def joined_active_fest
    self.fest_votes.includes(:fest).where(fests: {fest_status: "open"}).order(updated_at: :desc).first&.fest
  end
  
  # フェスIDを渡して投票レコードを取得する
  def my_vote(fest_id)
    self.fest_votes.find(fest_id: fest_id)
  end
  
  def set_account_token
    self.account_token = SecureRandom.urlsafe_base64
  end
end
