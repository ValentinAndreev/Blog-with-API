# frozen_string_literal: true

class User < ApplicationRecord
  include Authority::Abilities
  include Authority::UserAbilities

  authenticates_with_sorcery!

  has_many :posts
  has_many :comments
  has_one_attached :avatar

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, presence: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
                    uniqueness: { case_sensitive: false }
  validates :nickname, presence: true
  validates :avatar, blob: { content_type: ['image/png', 'image/jpg'], size_range: 0..3.megabytes }
end
