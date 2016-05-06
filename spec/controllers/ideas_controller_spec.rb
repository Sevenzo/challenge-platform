require 'rails_helper'
require 'support/standard_controller_actions'

describe IdeasController do

  let(:second_fragment) {
    idea_stage = create(:idea_stage)
    challenge.idea_stage = idea_stage
    idea_stage
  }

  let(:third_fragment) {
    problem_statement = create(:problem_statement)
    second_fragment.problem_statements << problem_statement
    problem_statement
  }

  let(:preexisting_entity) {
    idea = create(:idea, user: user, published_at: Time.now)
    third_fragment.ideas << idea
    idea
  }

  let(:unpublished_entity) {
    idea = create(:idea, user: user)
    third_fragment.ideas << idea
    idea
  }

  let(:redirect_path) {}

  let(:savable_entity) {
    {
      title: 'A generic title',
      description: 'this is a pretty bland description',
      problem_statement_id: third_fragment.id,
      published: 'true',
      file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','inflation.xls'))
    }
  }

  let(:draft_entity) {
    {
      title: 'A generic title',
      description: 'this is a pretty bland description',
      problem_statement_id: third_fragment.id,
      file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','inflation.xls'))
    }
  }

  let(:unsavable_entity) {
    {
      title: 'A generic title',
      description: 'this is a pretty broken description',
      problem_statement_id: third_fragment.id,
      link: 'ftp://google.com',
      file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','inflation.xls'))

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
      link: 'obex://www.yahoo.com',
      file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','inflation.xls'))
    }
  }

  include_examples 'a standard controller'
end
