FactoryGirl.define do
  
  sequence :subdomain do |n|
    "co#{n}"
  end
  
  factory :account do
    sequence(:name)  { |n| "Company #{n}" }
    subdomain { FactoryGirl.generate(:subdomain) }
  end
  
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    
    #factory :admin do
    #  admin true
    #end
  end
  
  factory :member do
    account
    user
  end
  
end