require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  describe '#author_of?(resource' do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:question) { create(:question, user: user_1) }

    it 'returns true if current user is an author of the question' do
      expect(user_1).to be_author_of(question)
    end

    it 'returns false if current user is not an author of the question' do
      expect(user_2).to_not be_author_of(question)
    end
  end
end
