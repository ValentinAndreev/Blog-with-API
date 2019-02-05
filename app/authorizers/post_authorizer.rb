# frozen_string_literal: true

class PostAuthorizer < ApplicationAuthorizer
  def deletable_by?(user)
    updatable_by?(user)
  end

  def updatable_by?(user)
    resource.user == user
  end
end
