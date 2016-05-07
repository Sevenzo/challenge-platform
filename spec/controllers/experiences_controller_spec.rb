require 'rails_helper'
require 'support/standard_controller_actions'

describe ExperiencesController do

  let(:second_fragment) {
    experience_stage = create(:experience_stage)
    challenge.experience_stage = experience_stage
    experience_stage
  }

  let(:third_fragment) {
    theme = create(:theme)
    second_fragment.themes << theme
    theme
  }

  let(:preexisting_entity) {
    experience = create(:experience, user: user, published_at: Time.now)
    third_fragment.experiences << experience
    experience
  }

  let(:unpublished_entity) {
    experience = create(:experience, user: user)
    third_fragment.experiences << experience
    experience
  }

  let(:redirect_path) {}

  let(:savable_entity) {
    {
      description: 'this is a pretty bland description',
      theme_id: third_fragment.id,
      published: 'true',
      file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','inflation.xls'))
    }
  }

  let(:draft_entity) {
    {
      description: 'this is a pretty bland description',
      theme_id: third_fragment.id,
      file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','inflation.xls'))
    }
  }

  let(:unsavable_entity) {
    {
      description: 'this is a pretty bad entity',
      link: 'ftp://google.com'
    }
  }

  let(:valid_patch_model) {
    {
      description: 'This is a much, much better description!!',
      link: 'http://www.yahoo.com',
      file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','inflation.xls'))
    }
  }

  let(:valid_patch_publish_model) {
    {
      description: 'This is a much, much better description!!',
      link: 'http://www.yahoo.com',
      published: 'true',
      file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','inflation.xls'))
    }
  }

  let(:invalid_patch_model) {
    {
      description: 'This is a much, much better description!!',
      link: 'sftp://www.yahoo.com'
    }
  }

  include_examples 'a standard controller'
end
