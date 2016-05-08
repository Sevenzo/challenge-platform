module Embeddable
  extend ActiveSupport::Concern
  include LinkHelper

  included do
    after_save :update_embed_code
  end

  def update_embed_code
    if link_changed? || embed.nil?
      if link.present?
        if IMAGE_EXTENSION_WHITELIST.any?{ |extension| link.end_with?(extension) }
          embed_code = ActionController::Base.helpers.image_tag(link, width: '100%')
        elsif ['youtube.com', 'youtu.be', 'vimeo.com'].any?{ |video| link.include?(video) }
          embed_code = video_embed(link)
        elsif link.include?('twitter.com')
          tweet_id = link.split('status/')[1]
          if tweet_id.present?
            twitter_rest_client = Twitter::REST::Client.new(TWITTER_CONFIG)
            tweet = twitter_rest_client.oembed(tweet_id)
            embed_code = tweet.html
          end
        end
      end

      update_column(:embed, embed_code)
    end
  rescue
  end

end
