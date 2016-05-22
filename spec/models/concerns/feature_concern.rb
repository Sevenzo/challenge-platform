require 'rails_helper'

shared_examples_for 'a featurable entity' do

  let(:panelists) {
    panelists = Array.new
    3.times do
      panelists.push(create(:user))
    end
    panelists
  }
  let(:challenge) { create(:challenge, :with_panelists, panelists: panelists) }

  it 'marks an entity as featured if feature is active' do
    create(:feature, featureable: entity, active: true)
    expect(entity.featured).to be true
  end

  it 'marks an entity as not feature if feature is inactive' do
    create(:feature, featureable: entity, active: false)
    expect(entity.featured).to be false
  end

end
