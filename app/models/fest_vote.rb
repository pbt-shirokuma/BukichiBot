class FestVote < ApplicationRecord
    
    # Relation
    belongs_to :fest , optional: true
    belongs_to :user , optional: true
    
    # validation
    validates :fest_id, presence: true
    validates :user_id, presence: true
    validates :selection, inclusion: { in: ["a","b"] }
    validates :game_count, numericality: true
    validates :win_count, numericality: true
    
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
