FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:email) { |i| "manabu-#{i}@example.com" }
    password { '12345678' } 
    password_confirmation { '12345678' } 
  end
end
