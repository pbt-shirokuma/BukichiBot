class User < ApplicationRecord

    # Relation
    has_many :messages
    has_many :fest_votes
    
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
