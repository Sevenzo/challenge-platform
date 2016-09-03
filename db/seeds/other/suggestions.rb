links = ["https://youtube.com/watch?v=rzfhs3M4lus", "https://twitter.com/MrBronke/status/559780396225662977", "https://vimeo.com/82083297", "https://assets.entrepreneur.com/content/16x9/822/20150903173413-books-shop-fair-library-used-bookshelf-literature-study-textbooks.jpeg", "https://c4.staticflickr.com/4/3553/3421529389_005faf57a5_b.jpg", nil]

## CREATING DEMO SUGGESTIONS
15.times do |time|
  Suggestion.create!(
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph(5),
    user_id: User.pluck(:id).sample,
    link: links.sample,
    created_at: time.days.ago
  )
end
