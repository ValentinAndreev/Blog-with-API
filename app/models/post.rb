# frozen_string_literal: true

class Post < ApplicationRecord
  include Authority::Abilities

  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
end
