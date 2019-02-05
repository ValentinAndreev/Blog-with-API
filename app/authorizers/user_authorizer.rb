# frozen_string_literal: true

class UserAuthorizer < ApplicationAuthorizer
  def updatable_by?(user)
    resource == user
  end

  def creatable_by?(_user)
    true
  end
end
