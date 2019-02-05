# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'comment body' }
    published_at { Time.now }
    post
    user
  end
end
