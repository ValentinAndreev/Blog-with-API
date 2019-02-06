# frozen_string_literal: true

require 'rails_helper'

describe 'Session API' do
  let(:user) { create :user, password: 'password', password_confirmation: 'password' }

  it 'recieve authorization token with right credentials' do
    post '/api/v1/authenticate', params: { email: user.email, password: 'password' }
    expect(response.status).to eq 200
    expect(JSON.parse(response.body)).to have_key('token')
  end

  it 'not recieve authorization token with wrong credentials' do
    post '/api/v1/authenticate', params: { email: 'mail@mail.com', password: 'new_password' }
    expect(response.status).to eq 401
    expect(JSON.parse(response.body)).to_not have_key('token')
  end
end
