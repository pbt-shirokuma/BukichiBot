# == Schema Information
#
# Table name: fests
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  fest_image  :string(255)
#  fest_name   :string(255)      not null
#  fest_result :string(255)
#  fest_status :integer          default("not_open"), not null
#  selection_a :string(255)      not null
#  selection_b :string(255)      not null
#  term_from   :datetime
#  term_to     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_fests_on_created_at  (created_at)
#  index_fests_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'digest'
class Fest < ApplicationRecord
    
  # Relation
  has_many :fest_votes, dependent: :destroy
  belongs_to :user
  
  # 未開催,開催中,集計中,終了
  enum fest_status: { not_open: 0, open: 1, totalize: 2, close: 3 }
  
  # validation
  validates :fest_name, presence: true
  validates :selection_a, presence: true , length: { maximum: 20 }
  validates :selection_b, presence: true , length: { maximum: 20 }
  validates :fest_result, inclusion: { in: ["a","b","draw"], allow_nil: true }
  validate :fest_open_is_only
  validate :fest_status_changeable
    
  before_save :fest_image_upload, if: ->{ 

    self.fest_image.present? && fest_image_changed? 
    
  }
    
  def fest_open_is_only
    if fest_status == "open"
      unless Fest.find_by(fest_status: "open").nil?
        errors.add(:fest_status, ": 他のフェスが開催中の為、このフェスはまだ開催できません。")
      end
    end
  end

  def fest_status_changeable
    # Nullの場合
    return if fest_status.nil?
    # 更新の場合
    unless new_record?
      case fest_status_in_database
      when "not_open"
        errors.add(:fest_status, "「未開催」から「集計中」には更新できません。") if ["20"].include?(fest_status)
      when "open"
        errors.add(:fest_status, "「開催中」から「未開催」、「終了」には更新できません。") if ["00","30"].include?(fest_status)
      when "totalize"
        errors.add(:fest_status, "「集計中」から「未開催」、「開催中」には更新できません。") if ["00","10"].include?(fest_status)
      when "close"
        errors.add(:fest_status, "「終了」状態のから他のステータスへ変更できません。") if ["00","10","20"].include?(fest_status)
      end
    end
  end
  
  def fest_result_display
    if self.fest_result.nil?
      "未集計"
    elsif self.fest_result == "draw"
      "引き分け" 
    elsif self.fest_result == "a"
      "WIN #{self.selection_a}"
    elsif self.fest_result == "b"
      "WIN #{self.selection_b}"
    end
  end
  
  def self.fest_statuses_i18n
    self.fest_statuses.keys.map do |st|
      [ st, I18n.t("enums.fest.fest_status.#{st}") ]
    end
  end
  
  def fest_image_file
    return nil if self.fest_image.nil?
    client = S3Client.new
    @fest_image_file ||= client.get_image(key: "fest_image/#{self.fest_image}")
  end
  
  def fest_image_file=(file)
    file_stream = file.read
    self.fest_image = Digest::MD5.hexdigest(file_stream)
    @fest_image_file = file_stream
  end
  
  def fest_result_detail
    win_rate_a = fest_votes.where(selection: 'a').average(:win_rate).to_f.round(3) * 100
    win_rate_b = fest_votes.where(selection: 'b').average(:win_rate).to_f.round(3) * 100
    { win_rate_a: win_rate_a, win_rate_b: win_rate_b }
  end
  
  private
  
  def fest_image_upload
    client = S3Client.new
    client.put_image(file: fest_image_file, key: "fest_image/#{self.fest_image}")
  end
end
