# == Schema Information
#
# Table name: messages
#
#  id             :bigint           not null, primary key
#  message_type   :string(255)
#  reply_response :text(65535)
#  request        :text(65535)
#  response       :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  message_id     :string(255)
#
# Indexes
#
#  index_messages_on_user_id_and_created_at  (created_at)
#
class Message < ApplicationRecord

    # Relation

    # 定数
    RESPONSE_FOLLOW_MESSAGE = {
                type: "text",
                text: "フォローありがとうでし！\n" +
                    "ブキの名前を言ってくれればブキの情報を教えるでし。\n" +
                    "ランダムにブキを選んで欲しいときはメニューから「ブキルーレット」を選ぶでし。"
            }
    RESPONSE_BLOCK_CANCEL_MESSAGE = {
                type: "text",
                text: "いらっしゃいでし！ブキの事ならなんでも聞くでし！"
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
