# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'post title' }
    body { 'post body' }
    published_at { Time.now }
    user
  end
end
