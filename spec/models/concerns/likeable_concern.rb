require 'rails_helper'

shared_examples_for 'likeable' do
  let(:model) { described_class.model_name.param_key.to_sym }

  it 'has a method that returns the default like' do
    subject = create(model)
    expect(subject.default_like).to eql DEFAULT_LIKE
  end

end
