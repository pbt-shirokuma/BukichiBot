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
