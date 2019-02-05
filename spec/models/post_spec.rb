# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'create valid post' do
    let(:post) { create :post }

    it { expect(post).to be_persisted }
  end

  context 'create invalid post' do
    subject { build(:post, body: nil) }

    it { is_expected.not_to be_valid }
  end
end
