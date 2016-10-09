require 'rails_helper'

describe User do

  it { is_expected.to have_and_belong_to_many(:states) }
  it { is_expected.to have_and_belong_to_many(:districts) }
  it { is_expected.to have_and_belong_to_many(:schools) }
  it { is_expected.to have_and_belong_to_many(:panels) }
  it { is_expected.to have_many(:experiences) }
  it { is_expected.to have_many(:ideas) }
  it { is_expected.to have_many(:recipes) }
  it { is_expected.to have_many(:solutions) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to belong_to(:referrer).class_name('User').with_foreign_key(:referrer_id) }
  it { is_expected.to have_many(:referrals).class_name('User').with_foreign_key(:referrer_id) }
  it { is_expected.to have_many(:identities) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_length_of(:last_name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:display_name).on(:update) }
  it { is_expected.to validate_length_of(:display_name).is_at_most(255).on(:update) }
  it { is_expected.to validate_presence_of(:role).on(:update) }
  it { is_expected.to validate_length_of(:role).is_at_most(255).on(:update) }
  it { is_expected.to validate_length_of(:organization).is_at_most(255) }
  it { is_expected.to validate_length_of(:title).is_at_most(255) }
  it { is_expected.to validate_length_of(:twitter).is_at_most(16) }

  describe '#has_draft_submissions?' do
    context 'with an entity that is unpublished' do
      let(:user) {
        create(:user)
      }

      let(:experience) {
        create_list(:experience, 1) + create_list(:experience, 5, published_at: Time.now)
      }

      let(:idea) {
        create_list(:idea, 1) + create_list(:idea, 5, published_at: Time.now)
      }

      let(:recipe) {
        create_list(:recipe, 1) + create_list(:recipe, 5, published_at: Time.now)
      }

      let(:solution) {
        create_list(:solution, 1) + create_list(:solution, 5, published_at: Time.now)
      }

      it 'returns true for an experience' do
        user.experiences << experience
        expect(user.has_draft_submissions?).to eq true
      end

      it 'returns true for an idea' do
        user.ideas << idea
        expect(user.has_draft_submissions?).to eq true
      end

      it 'returns true for an recipe' do
        user.recipes << recipe
        expect(user.has_draft_submissions?).to eq true
      end

      it 'returns true for a solution' do
        user.solutions << solution
        expect(user.has_draft_submissions?).to eq true
      end

      it 'returns true with an experience, idea, recipe, and solution unpublished' do
        user.experiences << experience
        user.ideas << idea
        user.recipes << recipe
        user.solutions << solution
        expect(user.has_draft_submissions?).to eq true
      end
    end

    context 'with no entities that are unpublished' do
      let(:user) {
        create(:user)
      }

      let(:experience) {
        create_list(:experience, 5, published_at: Time.now)
      }

      let(:idea) {
        create_list(:idea, 5, published_at: Time.now)
      }

      let(:recipe) {
        create_list(:recipe, 5, published_at: Time.now)
      }

      let(:solution) {
        create_list(:solution, 5, published_at: Time.now)
      }

      it 'returns false for an experience' do
        user.experiences << experience
        expect(user.has_draft_submissions?).to eq false
      end

      it 'returns false for an idea' do
        user.ideas << idea
        expect(user.has_draft_submissions?).to eq false
      end

      it 'returns false for an recipe' do
        user.recipes << recipe
        expect(user.has_draft_submissions?).to eq false
      end

      it 'returns false for a solution' do
        user.solutions << solution
        expect(user.has_draft_submissions?).to eq false
      end

      it 'returns false with an experience, idea, recipe, and solution all published' do
        user.experiences << experience
        user.ideas << idea
        user.recipes << recipe
        user.solutions << solution
        expect(user.has_draft_submissions?).to eq false
      end
    end
  end

end
