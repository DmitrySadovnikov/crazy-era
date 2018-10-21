FactoryBot.define do
  factory :user do
    email { 'email@email.com' }
    session_token { SecureRandom.hex }
  end
end
