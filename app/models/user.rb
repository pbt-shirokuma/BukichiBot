class User < ApplicationRecord

    # Relation
    has_many :fest
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
    
    def self.new_account_token
      SecureRandom.urlsafe_base64
    end
    
    def self.encrypt(token)
      Digest::SHA256.hexdigest(token.to_s)
    end
    
    def joined_active_fest?
      self.fest_votes.includes(:fest).where(fests: {fest_status: Fest::FEST_STATUS[:open]}).exists? 
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
