# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'create valid comment' do
    let(:comment) { create :comment }

    it { expect(comment).to be_persisted }
  end

  context 'create invalid comment' do
    subject { build(:comment, body: nil) }

    it { is_expected.not_to be_valid }
  end
end
