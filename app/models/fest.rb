class Fest < ApplicationRecord
    
    # Relation
    has_many :fest_votes
    
    # fest_status 定数
    FEST_STATUS = {
        :not_open => "00",
        :open => "10",
        :totalize => "20",
        :close => "30"
    }

    # validation
    validates :fest_name, presence: true
    validates :fest_status, inclusion: { in: Fest::FEST_STATUS.values }
    validates :selection_a, presence: true , length: { maximum: 20 }
    validates :selection_b, presence: true , length: { maximum: 20 }
    validates :fest_result, inclusion: { in: ["a","b",nil] }
    validate :fest_open_is_only
    
    def fest_open_is_only
        if fest_status == Fest::FEST_STATUS[:open]
            unless Fest.find_by_fest_status(Fest::FEST_STATUS[:open]).nil?
                errors.add(:fest_status, ": 他のフェスが開催中の為、このフェスはまだ開催できません。")
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
