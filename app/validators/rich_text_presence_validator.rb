class RichTextPresenceValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless ActionController::Base.helpers.strip_tags(value).present?
      record.errors[attribute] << I18n.t('errors.messages.blank')
    end
  end

end
