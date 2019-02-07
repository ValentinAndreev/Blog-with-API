# frozen_string_literal: true

require 'rails_helper'

describe 'Post API' do
  let(:user) { create :user, password: 'password', password_confirmation: 'password' }
  let!(:posts) { create_list(:post, 11) }

  before { post '/api/v1/authenticate', params: { email: user.email, password: 'password' } }
  let(:token) { JSON.parse(response.body)['token'] }

  context 'with authorization token' do
    it 'return post by id' do
      get "/api/v1/posts/#{posts.first.id}", headers: { 'Authorization' => token }
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['id']).to eq posts.first.id
    end

    it 'create post with title and body' do
      expect do
        post '/api/v1/posts.json', params: { title: 'new_title', body: 'new_body' }, headers: { 'Authorization' => token }
      end .to change(Post.all, :count).by(1)
      expect(response.status).to eq 200
    end

    it 'return errors if title or body not exists' do
      expect { post '/api/v1/posts.json', headers: { 'Authorization' => token } }.not_to change(Post.all, :count)
      expect(response.status).to eq 422
      expect(response.body).to include("Title can't be blank", "Body can't be blank")
    end

    it 'return posts by page and per_page parameters' do
      get '/api/v1/posts.json', params: { page: 2, per_page: 2 }, headers: { 'Authorization' => token }
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).count).to eq 2
      expect(response.headers['Total-pages']).to eq 6
      expect(response.headers['Total-records']).to eq 11
    end

    it 'with all parameters return report' do
      post '/api/v1/reports/by_author.json', params: { start_date: Date.today, end_date: Date.today + 1.day, email: 'mail@mail.com' },
                                             headers: { 'Authorization' => token }
      expect(response.status).to eq 200
    end

    it 'report return errors if some parameters missing' do
      post '/api/v1/reports/by_author.json', headers: { 'Authorization' => token }
      expect(response.status).to eq 422
      expect(response.body).to include('error', 'start_date', 'end_date', 'email')
    end
  end

  context 'without authorization token' do
    it 'not return post by id' do
      get "/api/v1/posts/#{posts.first.id}"
      expect(response.status).to eq 401
    end

    it 'not create post' do
      expect { post '/api/v1/posts.json', params: { title: 'new_title', body: 'new_body' } }.not_to change(Post.all, :count)
      expect(response.status).to eq 401
    end

    it 'not return posts by page and per_page parameters' do
      get '/api/v1/posts.json', params: { page: 2, per_page: 2 }
      expect(response.status).to eq 401
    end

    it 'not return report' do
      post '/api/v1/reports/by_author.json', params: { start_date: Date.today, end_date: Date.today + 1.day, email: 'mail@mail.com' }
      expect(response.status).to eq 401
    end
  end
end
