class Fest < ApplicationRecord
    
    # Relation
    has_many :fest_votes
    belongs_to :user
    
    # fest_status 定数
    FEST_STATUS = {
        :not_open => "00", # 未開催
        :open => "10",     # 開催中
        :totalize => "20", # 集計中
        :close => "30"     # 終了
    }

    # validation
    validates :fest_name, presence: true
    validates :fest_status, inclusion: { in: Fest::FEST_STATUS.values }
    validates :selection_a, presence: true , length: { maximum: 20 }
    validates :selection_b, presence: true , length: { maximum: 20 }
    validates :fest_result, inclusion: { in: ["a","b","draw",nil] }
    validate :fest_open_is_only
    validate :fest_status_changeable
    
    def fest_open_is_only
        if fest_status == Fest::FEST_STATUS[:open]
            unless Fest.find_by_fest_status(Fest::FEST_STATUS[:open]).nil?
                errors.add(:fest_status, ": 他のフェスが開催中の為、このフェスはまだ開催できません。")
            end
        end
    end
    
    def fest_status_changeable
        
        # Nullの場合
        if fest_status.nil?
            return
        end
        
        # 更新の場合
        unless new_record?
            case fest_status_in_database
            when Fest::FEST_STATUS[:not_open]
                if ["20"].include?(fest_status)
                    errors.add(:fest_status, "「未開催」から「集計中」には更新できません。")
                end
            when Fest::FEST_STATUS[:open]
                if ["00","30"].include?(fest_status)
                    errors.add(:fest_status, "「開催中」から「未開催」、「終了」には更新できません。")
                end
            when Fest::FEST_STATUS[:totalize]
                if ["00","10"].include?(fest_status)
                    errors.add(:fest_status, "「集計中」から「未開催」、「開催中」には更新できません。")
                end
            when Fest::FEST_STATUS[:close]
                if ["00","10","20"].include?(fest_status)
                    errors.add(:fest_status, "「終了」状態のから他のステータスへ変更できません。")
                end
            end
        end
    end
    
    # アクセサ
    def created_at
        unless read_attribute(:created_at).nil?
            read_attribute(:created_at).strftime("%Y/%m/%d %H:%M:%S") 
        end
    end
    def updated_at
        unless read_attribute(:updated_at).nil?
            read_attribute(:updated_at).strftime("%Y/%m/%d %H:%M:%S") 
        end
    end

end
