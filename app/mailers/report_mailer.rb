# frozen_string_literal: true

class ReportMailer < ApplicationMailer
  def report
    mail(to: params[:email], subject: "Report about user's activity.")
  end
end
