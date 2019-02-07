# frozen_string_literal: true

class ReportGenerationJob < ApplicationJob
  queue_as :default

  def perform(start_date, end_date, email)
    posts = posts(start_date, end_date)
    comments = comments(start_date, end_date)
    users = posts.merge(comments).keys
    ReportMailer.with(email: email, report: report(users, posts, comments), start_date: start_date, end_date: end_date).report.deliver_now
  end

  private

  def report(users, posts, comments)
    report = []
    users.each do |user|
      report << [user.nickname, user.email, posts[user] || 0, comments[user] || 0, posts[user].to_f + comments[user].to_f / 10]
    end
    report.sort_by { |e| -e[4] }
  end

  def posts(start_date, end_date)
    Post.where('published_at > ? AND published_at < ?', start_date.to_date, end_date.to_date).group(:user).count
  end

  def comments(start_date, end_date)
    Comment.where('published_at > ? AND published_at < ?', start_date.to_date, end_date.to_date).group(:user).count
  end
end
