require 'rails_helper'

shared_examples_for 'normalizable' do
  let(:model) { described_class.model_name.param_key.to_sym }

  it 'normalizes URLs without a protocol' do
    subject = create(model, link: 'google.com')
    expect(subject.link).to eql 'http://google.com'
  end

  it 'does not normalize URLs with the HTTP protocol' do
    subject = create(model, link: 'http://google.com')
    expect(subject.link).to eql 'http://google.com'
  end

  it 'does not normalize URLs with the HTTPS protocol' do
    subject = create(model, link: 'https://google.com')
    expect(subject.link).to eql 'https://google.com'
  end

  it 'normalizes URLs with the WWW protocol' do
    subject = create(model, link: 'www.google.com')
    expect(subject.link).to eql 'http://www.google.com'
  end

  it 'does not normalize a nil URL' do
    subject = create(model, link: nil)
    expect(subject.link).to be_nil
  end
end
