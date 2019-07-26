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