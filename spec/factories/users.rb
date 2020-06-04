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
FactoryBot.define do

  factory :user , class: User do
    id { 1 }
    name {"test user"}
    line_id {"U01c7d4ac06b42fb8c59c2a1256604ccc"}
    status {"00"}
    talk_status {"00"}
    del_flg {false}
  end

end
