# encoding: utf-8
class RedactorRailsPictureUploader < CarrierWave::Uploader::Base
  include RedactorRails::Backend::CarrierWave

  include CarrierWave::MiniMagick

  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}/pictures"
  end

  process :read_dimensions

  version :thumb do
    process resize_to_fill: [118, 100]
  end

  version :content do
    process resize_to_limit: [500, -1]
  end

  def extension_white_list
    RedactorRails.image_file_types
  end
end
