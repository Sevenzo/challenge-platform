require 'rails_helper'

class RichTextValidatable
  include ActiveModel::Validations
  validates_with RichTextPresenceValidator, attributes: :description
  attr_accessor :description
end

describe RichTextPresenceValidator do
  subject { RichTextValidatable.new }

  it 'does not validate a blank html entry' do
    subject.description = '<p><br></p>'
    expect(subject).to_not be_valid
    expect(subject.errors.full_messages).to eq ["Description can't be blank"]
  end

  it 'does not validate an empty string' do
    subject.description = ''
    expect(subject).to_not be_valid
    expect(subject.errors.full_messages).to eq ["Description can't be blank"]
  end

  it 'does not validate nil' do
    subject.description = nil
    expect(subject).to_not be_valid
    expect(subject.errors.full_messages).to eq ["Description can't be blank"]
  end

  it 'validates content' do
    subject.description = 'this is content'
    expect(subject).to be_valid
  end

  it 'validates rich content' do
    subject.description = '<h1>this is content</h1>'
    expect(subject).to be_valid
  end

end
