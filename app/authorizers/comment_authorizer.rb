# frozen_string_literal: true

class CommentAuthorizer < ApplicationAuthorizer
  def deletable_by?(user)
    resource.user == user
  end
end
