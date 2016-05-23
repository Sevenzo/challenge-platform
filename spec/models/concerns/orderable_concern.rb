require 'rails_helper'

shared_examples_for 'orderable' do

  let(:model) { described_class.model_name.param_key.to_sym }
  let(:commenter) { create(:user) }

  before(:each) do
    6.times do |time|
      entity = create(model, created_at: time.days.ago, published_at: time.days.from_now)
      time.times { add_comment(entity) } if time.odd?
    end
  end

  it 'creates the correct number of entities' do
    expect(described_class.count).to eq 6
    expect(Comment.count).to eq 9
  end

  it 'sorts by comment counts desc' do
    expect(described_class.pluck(:comments_count).uniq).to eq [5,3,1,0]
  end

  it 'sorts by featured first, then comments count' do
    featured = described_class.second
    featured.update!(featured: true)
    expect(described_class.first.id).to eq featured.id
    expect(described_class.last.comments_count).to eq 0
  end

  context 'when there are no comments' do
    before { Comment.all.each(&:destroy) }

    it 'sorts by published_at desc count' do
      first_id = described_class.first.id
      expected_id_array = (first_id-5..first_id).to_a.reverse
      expect(described_class.pluck(:id)).to eq expected_id_array
    end

    it 'sorts by featured, then published_at desc count' do
      first_id = described_class.first.id
      expected_id_array = (first_id-5..first_id).to_a.reverse

      featured = described_class.last
      featured.update!(featured: true)

      expected_id_array.unshift(featured.id)
      expected_id_array.pop

      expect(described_class.pluck(:id)).to eq expected_id_array
    end
  end

private

  def add_comment(entity)
    comment = Comment.build_from(entity, commenter.id, {body: "Test comment"})
    comment.save!
  end

end
