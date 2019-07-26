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