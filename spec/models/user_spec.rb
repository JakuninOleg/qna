require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  describe '#author_of?(resource' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users[0]) }

    it 'returns true if current user is an author of the question' do
      expect(users[0].author_of?(question)).to eq true
    end

    it 'returns false if current user is not an author of the question' do
      expect(users[1].author_of?(question)).to eq false
    end
  end
end
