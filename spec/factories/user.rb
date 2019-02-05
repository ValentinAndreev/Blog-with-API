# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@mail.com" }
    sequence(:nickname) { |n| "name#{n}" }
    password { 'secret' }
    password_confirmation { 'secret' }
    salt { 'clbjvbndfobinl' }
    crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt('secret', salt) }
  end
end
