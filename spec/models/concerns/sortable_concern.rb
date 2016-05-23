require 'rails_helper'

shared_examples_for 'sortable' do

  let(:model) { described_class.model_name.param_key.to_sym }

  before(:each) do
    6.times { |time| create(model, created_at: time.days.ago) }
  end

  it 'creates the correct number of entities' do
    expect(described_class.count).to eq 6
  end

  it 'sorts by created_at DESC when passed in' do
    first_id = described_class.unscoped.first.id
    expected_id_array = (first_id..first_id+5).to_a
    expect(described_class.order_by('created_at DESC').pluck(:id)).to eq expected_id_array
  end

  it 'sorts by created_at ASC when passed in' do
    last_id = described_class.unscoped.last.id
    expected_id_array = (last_id-5..last_id).to_a.reverse
    expect(described_class.order_by('created_at ASC').pluck(:id)).to eq expected_id_array
  end

end
