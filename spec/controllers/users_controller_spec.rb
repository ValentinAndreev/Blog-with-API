# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    let(:default_attributes) { attributes_for :user }

    context 'register new user with correct params' do
      let(:params) { { user: default_attributes.except(:crypted_password, :salt) } }

      subject { post 'create', params: params }

      it 'saves new user to database' do
        expect { subject }.to change(User.all, :count).by(1)
      end

      context 'login registred' do
        before do
          post 'create', params: params
        end

        it 'redirects to main page' do
          expect(response).to redirect_to(root_path)
        end

        it 'user auto login' do
          expect(logged_in?).to be_truthy
        end
      end
    end

    context 'register with incorrect attributes' do
      let(:params) { Hash(user: attributes_for(:user).except(:crypted_password, :salt, :email)) }

      before do
        post 'create', params: params
      end

      it 'not save new user to database' do
        expect { subject }.not_to change(User.all, :count)
      end

      it 'should render login page' do
        expect(response).to render_template(:new)
      end

      it 'user not login' do
        expect(logged_in?).to be_falsey
      end
    end
  end

  describe 'PUT #update' do
    context 'update user with correct params' do
      let(:user) { create(:user) }
      let(:new_password) { 'newpassword' }
      let(:params) do
        Hash(id: user.id, user: { email: user.email,
                                  password: new_password,
                                  password_confirmation: new_password })
      end

      before do
        login_user(user)
        put 'update', params: params
      end

      it 'updates user password' do
        expect(user.reload.valid_password?(new_password)).to be_truthy
      end

      it 'should render template' do
        expect(response).to render_template(:edit)
      end

      it 'user auto login after update' do
        expect(logged_in?).to be_truthy
      end
    end

    context 'update user with incorrect attributes' do
      let(:user) { create :user }
      let(:params) do
        Hash(id: user.id, user: { email: user.email,
                                  password: 'newpassword',
                                  password_confirmation: 'newpassword2' })
      end

      before do
        login_user(user)
        put 'update', params: params
      end

      it 'not updates user password' do
        expect(user.reload.valid_password?('newpassword')).to be_falsey
      end

      it 'should render template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'other user cant edit profile' do
      let(:user) { create :user }
      let(:other_user) { create :user }
      let(:new_password) { 'newpassword' }
      let(:params) do
        Hash(id: user.id, user: { email: user.email,
                                  password: new_password,
                                  password_confirmation: new_password })
      end

      before do
        login_user(other_user)
        put 'update', params: params
      end

      it 'not updates user password' do
        expect(user.reload.valid_password?('newpassword')).to be_falsey
      end
    end
  end
end
