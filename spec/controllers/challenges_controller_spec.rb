require 'rails_helper'

describe ChallengesController do
  let(:challenge) { create(:challenge) }

  describe "GET #show" do
    it 'finds the challenge with the specified id' do
      get :show, id: challenge.id
      expect(assigns(:challenge)).to eq challenge
    end

    it 'renders the view if provided the slug' do
      get :show, id: challenge.slug
      expect(response).to render_template :show
    end

    it 'redirects to the slug url if given an id' do
      get :show, id: challenge.id
      expect(response).to redirect_to challenge_path(challenge)
    end
  end

  describe "GET #drawing" do
    it 'finds the challenge with the specified id' do
      get :drawing, id: challenge.id
      expect(assigns(:challenge)).to eq challenge
    end

    it 'renders the view' do
      get :drawing, id: challenge.id
      expect(response).to render_template :drawing
    end
  end
end
