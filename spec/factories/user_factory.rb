FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    phone_number Faker::PhoneNumber.phone_number
    password "password"
    password_confirmation "password"
  end
end
