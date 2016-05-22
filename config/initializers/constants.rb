IMAGE_EXTENSION_WHITELIST = %w(jpg jpeg gif png).freeze
FILE_EXTENSION_WHITELIST = %w(pdf csv doc docx xls xlsx ppt pptx).freeze

DEFAULT_LIKE = {
  scope: 'like',
  liked: {
    name: 'Liked',
    icon: 'fa fa-thumbs-up'
  },
  unliked: {
    name: 'Like',
    icon: 'fa fa-thumbs-o-up'
  }
}.freeze

OPEN_RECIPE_SUBMISSIONS = false
