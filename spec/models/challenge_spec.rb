require 'rails_helper'

describe Challenge do

  it { is_expected.to have_one(:panel) }
  it { is_expected.to have_one(:experience_stage) }
  it { is_expected.to have_one(:idea_stage) }
  it { is_expected.to have_one(:recipe_stage) }
  it { is_expected.to have_one(:solution_stage) }


  context 'when displaying featured contributions for a particular stage' do

    let(:challenge) {
      create(:challenge)
    }

    let(:experience_stage) {
      theme = create(:theme)
      experience_stage = create(:experience_stage)
      15.times do |n|
        experience = create(:experience, published_at: Time.now)
        theme.experiences << experience
        create(:feature, featureable: experience, challenge: challenge, active: n < 3)
      end

      experience_stage.themes << theme
      experience_stage
    }

    let(:idea_stage) {
      problem_statement = create(:problem_statement)
      idea_stage = create(:idea_stage)
      15.times do |n|
        idea = create(:idea, published_at: Time.now)
        problem_statement.ideas << idea
        create(:feature, featureable: idea, challenge: challenge, active: n < 3)
      end

      idea_stage.problem_statements << problem_statement
      idea_stage
    }

    let(:recipe_stage) {
      cookbook = create(:cookbook)
      recipe_stage = create(:recipe_stage)
      15.times do |n|
        recipe = create(:recipe, published_at: Time.now)
        cookbook.recipes << recipe
        create(:feature, featureable: recipe, challenge: challenge, active: n < 3)
      end

      recipe_stage.cookbooks << cookbook
      recipe_stage
    }

    let(:solution_stage) {
      solution_stage = create(:solution_stage)
      15.times do |n|
        solution = create(:solution, published_at: Time.now)
        solution_story = create(:solution_story, solution: solution)
        create(:feature, featureable: solution, challenge: challenge, active: n < 3)
        solution_stage.solution_stories << solution_story
      end

      solution_stage
    }

    before(:each) do
      challenge.experience_stage = experience_stage
      challenge.idea_stage = idea_stage
      challenge.recipe_stage = recipe_stage
      challenge.solution_stage = solution_stage
    end

    it 'shows the top two featured experiences' do
      challenge.active_stage = 'experience'
      result = challenge.featured_contributions
      expect(result.size).to eq 2
      expect(result.first.feature.active).to eq true
      expect(result.last.feature.active).to eq true
      expect(result.to_ary.map(&:class).all? { |cls| cls == Experience }).to eq true
    end

    it 'shows the top three featured ideas' do
      challenge.active_stage = 'idea'
      result = challenge.featured_contributions
      expect(result.size).to eq 3
      expect(result.first.feature.active).to be true
      expect(result.second.feature.active).to be true
      expect(result.last.feature.active).to be true
      expect(result.to_ary.map(&:class).all? { |cls| cls == Idea }).to eq true
    end

    it 'shows the top two featured recipes' do
      challenge.active_stage = 'recipe'
      result = challenge.featured_contributions
      expect(result.size).to eq 2
      expect(result.first.feature.active).to eq true
      expect(result.last.feature.active).to eq true
      expect(result.to_ary.map(&:class).all? { |cls| cls == Recipe }).to eq true
    end

    it 'shows the top two featured solutions' do
      challenge.active_stage = 'solution'
      result = challenge.featured_contributions
      expect(result.size).to eq 2
      expect(result.first.feature.active).to eq true
      expect(result.last.feature.active).to eq true
      expect(result.to_ary.map(&:class).all? { |cls| cls == Solution }).to eq true
    end

    it 'returns nothing for a bogus stage' do
      challenge.active_stage = 'bogus'
      result = challenge.featured_contributions
      expect(result).to be_nil
    end
  end

  describe '#has_featured_for' do

    let(:first_challenge) {
      create(:challenge)
    }

    let(:second_challenge) {
      create(:challenge)
    }

    let(:experience_stage) {
      theme = create(:theme)
      experience_stage = create(:experience_stage)
      15.times do |n|
        experience = create(:experience, published_at: Time.now)
        theme.experiences << experience
        create(:feature, featureable: experience, challenge: first_challenge, active: n < 3)
      end

      experience_stage.themes << theme
      experience_stage
    }

    let(:idea_stage) {
      problem_statement = create(:problem_statement)
      idea_stage = create(:idea_stage)
      15.times do |n|
        idea = create(:idea, published_at: Time.now)
        problem_statement.ideas << idea
        create(:feature, featureable: idea, challenge: first_challenge, active: n < 3)
      end

      idea_stage.problem_statements << problem_statement
      idea_stage
    }

    let(:recipe_stage) {
      cookbook = create(:cookbook)
      recipe_stage = create(:recipe_stage)
      15.times do |n|
        recipe = create(:recipe, published_at: Time.now)
        cookbook.recipes << recipe
        create(:feature, featureable: recipe, challenge: first_challenge, active: n < 3)
      end

      recipe_stage.cookbooks << cookbook
      recipe_stage
    }

    let(:solution_stage) {
      solution_stage = create(:solution_stage)
      15.times do |n|
        solution = create(:solution, published_at: Time.now)
        solution_story = create(:solution_story, solution: solution)
        create(:feature, featureable: solution, challenge: first_challenge, active: n < 3)
        solution_stage.solution_stories << solution_story
      end

      solution_stage
    }

    before(:each) do
      first_challenge.experience_stage = experience_stage
      first_challenge.idea_stage = idea_stage
      first_challenge.recipe_stage = recipe_stage
      first_challenge.solution_stage = solution_stage
    end

    context 'with a challenge that has featured entities' do
      it 'returns true for Experiences' do
        expect(first_challenge.has_featured_for('Experience')).to be true
      end

      it 'returns true for Ideas' do
        expect(first_challenge.has_featured_for('Idea')).to be true
      end

      it 'returns true for Recipes' do
        expect(first_challenge.has_featured_for('Recipe')).to be true
      end

      it 'returns true for Solutions' do
        expect(first_challenge.has_featured_for('Solution')).to be true
      end
    end

    context 'with a challenge that has no featured entities' do
      it 'returns false for Experiences' do
        expect(second_challenge.has_featured_for('Experience')).to be false
      end

      it 'returns false for Ideas' do
        expect(second_challenge.has_featured_for('Idea')).to be false
      end

      it 'returns false for Recipes' do
        expect(second_challenge.has_featured_for('Recipe')).to be false
      end

      it 'returns false for Solutions' do
        expect(second_challenge.has_featured_for('Solution')).to be false
      end
    end
  end
end
