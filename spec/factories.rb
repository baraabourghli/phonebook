FactoryGirl.define do

  factory :contact do
    sequence(:full_name) { |n| "John #{n}" }
    sequence(:number) { |number| "#{number}" }
  end

end