shared_examples_for "rateable" do
  it { should have_many(:ratings).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:resource) { create(:question, user: user) }

  describe '#vote_up(user)' do
    it 'adds a positive voice' do
      resource.vote_up(user)
      expect(resource.votes).to eq 1
    end

    it 'the vote being accepted' do
      expect { resource.vote_up(user) }.to change(resource.ratings, :count).by(1)
    end
  end

  describe '#vote_down(user)' do
    it 'adds a negative voice' do
      resource.vote_down(user)
      expect(resource.votes).to eq -1
    end

    it 'the vote being accepted' do
      expect { resource.vote_down(user) }.to change(resource.ratings, :count).by(1)
    end
  end

  describe '#reset_vote(user)' do
    it 'rating deleted' do
      resource.vote_up(user)

      expect { resource.reset_vote(user) }.to change(resource.ratings, :count).by(-1)
    end
  end

  describe '#vote' do
    it 'counts votes properly' do
      resource.vote_up(user)
      resource.vote_down(user_2)
      expect(resource.votes).to eq 0
    end
  end

  describe '#voted_by?(user)' do
    it 'user voted' do
      resource.vote_up(user)
      expect(resource).to be_voted_by(user)
    end

    it 'user did not vote' do
      expect(resource).to_not be_voted_by(user)
    end
  end
end
