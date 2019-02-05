# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    context 'saves new comment with correct params and logined user' do
      let(:user) { create :user }
      let(:new_post) { create :post }

      before { login_user(user) }

      subject { post 'create', params: { comment: attributes_for(:comment), post_id: new_post.id } }

      it 'saves new comment to database' do
        expect { subject }.to change(Comment.all, :count).by(1)
      end
    end

    context 'not saves new comment without logined user' do
      let(:new_post) { create :post }

      subject { post 'create', params: { comment: attributes_for(:comment), post_id: new_post.id } }

      it 'not saves new comment to database' do
        expect { subject }.not_to change(Comment.all, :count)
      end
    end

    context 'user can delete own comments' do
      let(:user) { create :user }
      let(:post) { create :post }
      let(:comment) { create(:comment, user: user, post: post) }

      before do
        login_user(user)
        delete 'destroy', params: { id: comment.id, post_id: post.id }
      end

      it 'delete comment' do
        expect(Comment.exists?(comment.id)).to eq false
      end
    end

    context "user can't delete other user comments" do
      let(:user) { create :user }
      let(:other_user) { create :user }
      let(:post) { create :post }
      let(:comment) { create(:comment, user: other_user, post: post) }

      before do
        login_user(user)
        delete 'destroy', params: { id: comment.id, post_id: post.id }
      end

      it 'delete comment' do
        expect(Comment.exists?(comment.id)).to eq true
      end
    end
  end
end
