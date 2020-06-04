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
FactoryBot.define do

  factory :fest , class: Fest do
    id { 1 }
    fest_name {"TEST FEST"}
    fest_status {"00"}
    selection_a {"HOGE"}
    selection_b {"FUGA"}
    fest_result { nil }
  end

end
