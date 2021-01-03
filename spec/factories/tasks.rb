FactoryBot.define do
  factory :task, class: Task do
    sequence(:title) { |i| "title-#{i}" }
    status { 0 }
    association :user
  end
end
