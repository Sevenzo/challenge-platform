require 'rails_helper'

shared_examples_for 'a featurable entity' do

  let(:non_panelist) {
    create(:user)
  }

  let(:panelists) {
    panelists = Array.new
    3.times do
      panelists.push(create(:user))
    end
    panelists
  }

  let(:challenge) {
    create(:challenge, :with_panelists, panelists: panelists)
  }

  let(:feature) {
    create(:feature, challenge: challenge, featureable: entity)
  }

  it 'marks an entity with a non-panelist as invalid' do
    feature.featureable = entity
    feature.user = non_panelist
    expect(feature.valid?).to eq false
  end

  it 'marks an entity with a panelist as valid' do
    feature.featureable = entity
    feature.user = panelists.first
    expect(feature.valid?).to eq true
  end

  it 'marks an entity without a user as valid' do
    feature.featureable = entity
    expect(feature.valid?).to eq true
  end
end
