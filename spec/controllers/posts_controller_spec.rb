# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'POST #create' do
    context 'saves new post with correct params and logined user' do
      let(:user) { create :user }

      before { login_user(user) }

      subject { post 'create', params: { post: attributes_for(:post) } }

      it 'saves new post to database' do
        expect { subject }.to change(Post.all, :count).by(1)
      end
    end

    context 'not saves new post without logined user' do
      subject { post 'create', params: { post: attributes_for(:post) } }

      it 'not saves new post to database' do
        expect { subject }.not_to change(Post.all, :count)
      end
    end

    context '#show to logined user' do
      let(:post) { create :post }
      let(:user) { create :user }

      before { login_user(user) }

      subject { get :show, params: { id: post.id } }

      it { is_expected.to render_template(:show) }
      it 'should respond with a success status code (2xx)' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'show must redirects to login page for not logined user' do
      let(:post) { create :post }

      subject { get :show, params: { id: post.id } }

      it { is_expected.to redirect_to(login_path) }
    end

    context 'user can update own posts' do
      let(:user) { create :user }
      let(:post) { create(:post, user: user) }

      before do
        login_user(user)
        put 'update', params: { id: post.id, post: attributes_for(:post, body: 'New post body') }
      end

      it 'updates post body' do
        expect(post.reload.body).to eq 'New post body'
      end
    end

    context "user can't update other user posts" do
      let(:user) { create :user }
      let(:other_user) { create :user }
      let(:post) { create(:post, user: other_user) }

      before do
        login_user(user)
        put 'update', params: { id: post.id, post: attributes_for(:post, body: 'New post body') }
      end

      it 'not updates post body' do
        expect(post.reload.body).to eq 'post body'
      end
    end

    context 'user can delete own posts' do
      let(:user) { create :user }
      let(:post) { create(:post, user: user) }

      before do
        login_user(user)
        delete 'destroy', params: { id: post.id }
      end

      it 'delete post' do
        expect(Post.exists?(post.id)).to eq false
      end
    end

    context "user can't delete other user posts" do
      let(:user) { create :user }
      let(:other_user) { create :user }
      let(:post) { create(:post, user: other_user) }

      before do
        login_user(user)
        delete 'destroy', params: { id: post.id }
      end

      it 'delete post' do
        expect(Post.exists?(post.id)).to eq true
      end
    end
  end
end
