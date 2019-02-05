# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }

    context 'login with correct email and password' do
      before do
        post 'create', params: { user: { email: user.email, password: 'secret' } }
      end

      it 'user logged in' do
        expect(logged_in?).to eq true
      end

      it 'redirects to main page' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'login with incorrect email and password' do
      before do
        post 'create', params: { user: { email: user.email, password: 'secrets' } }
      end

      it 'user not logged in' do
        expect(logged_in?).to be_falsey
      end

      it 'redirects to login page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user }

    before do
      login_user(user, 'secret')
      delete 'destroy', params: { id: user.id }
    end

    it 'session is destroyed' do
      expect(logged_in?).to be_falsey
    end

    it 'redirects to main page' do
      expect(response).to redirect_to(root_path)
    end
  end
end
