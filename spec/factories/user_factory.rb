FactoryGirl.define do
  factory :user do
    email Faker::Internet.unique.email
    phone_number Faker::PhoneNumber.phone_number
    password "password"
    password_confirmation "password"
  end
end
