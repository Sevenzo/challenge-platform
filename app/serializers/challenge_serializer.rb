class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :background, :help, :outcome, :video_url

end
