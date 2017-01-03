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
  it { is_expected.to have_many(:identities).dependent(:destroy) }
  it { is_expected.to have_many(:scheduled_notifications).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_length_of(:last_name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:display_name).on(:update) }
  it { is_expected.to validate_length_of(:display_name).is_at_most(255).on(:update) }
  it { is_expected.to validate_presence_of(:role).on(:update) }
  it { is_expected.to validate_length_of(:role).is_at_most(255).on(:update) }
  it { is_expected.to validate_presence_of(:organization).on(:update) }
  it { is_expected.to validate_length_of(:organization).is_at_most(255).on(:update) }
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

    context 'digest notifications' do
      context '#digest_options' do
        it 'should get the digest frequency options as an array' do
          expect(User.digest_options).to eq ['immediate', 'daily', 'weekly']
        end
      end

      context '#digest_frequency_unit' do
        let(:user) {
          create(:user, email: 'foo@bar.baz', digest_frequency: digest_frequency)
        }

        context 'digest frequency unit aliased from a `daily` digest frequncy' do
          let(:digest_frequency) { 'immediate' }

          it 'should get the unit for `immediate` digest frequency' do
            expect(user.digest_frequency_unit).to be_nil
          end
        end

        context 'digest frequency unit aliased from a `daily` digest frequncy' do
          let(:digest_frequency) { 'daily' }

          it 'should get the unit for `daily` digest frequency' do
            expect(user.digest_frequency_unit).to eq 'day'
          end
        end

        context 'digest frequency unit aliased from a `weekly` digest frequncy' do
          let(:digest_frequency) { 'weekly' }

          it 'should get the unit for `daily` digest frequency' do
            expect(user.digest_frequency_unit).to eq 'week'
          end
        end
      end

      context '#immediate' do
        let(:user) {
          create(:user, email: 'foo@bar.baz') # digest_frequency defaults to `immediate`
        }

        it 'should create a user with a daily `digest_frequency`' do
          expect(user.immediate?).to eq true
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context '#dialy' do
        let(:user) {
          create(:user, email: 'foo@bar.baz', digest_frequency: 'daily')
        }

        it 'should create a user with a daily `digest_frequency`' do
          expect(user.daily?).to eq true
        end
      end

      context '#weekly' do
        let(:user) {
          create(:user, email: 'foo@bar.baz', digest_frequency: 'weekly')
        }

        it 'should create a user with a weekly `digest_frequency`' do
          expect(user.weekly?).to eq true
        end
      end
    end
  end

end
