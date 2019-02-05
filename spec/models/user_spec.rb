# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'create valid user' do
    let(:user) { create :user }

    it { expect(user).to be_persisted }
  end

  context 'create invalid user' do
    subject { build(:user, email: 'abcd@') }

    it { is_expected.not_to be_valid }
  end
end
