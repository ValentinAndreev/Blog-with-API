# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :published_at, :author_nickname

  def author_nickname
    object.user.nickname
  end
end
