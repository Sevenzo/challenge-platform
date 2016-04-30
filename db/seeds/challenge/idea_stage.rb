challenge = Challenge.find(1)
challenge.update_column(:active_stage, 'idea')

## CREATING IDEATION STAGE
idea_stage = challenge.create_idea_stage!(
  title: "Contribute your ideas!",
  description: "Now it’s time to get creative on ways to improve the experiences you shared in <a href='#'>Stage 1</a>. If you’ve already completed that stage, let the ideas roll!",
  incentive: "Participate and you could win a $50 gift card. Those with the best ideas go to Innovator's Weekend July 31-August 2. (<a href='#'>see contest rules</a>)",
  active: true,
  public: true, 
  starts_at: 5.days.from_now, 
  ends_at: 10.days.from_now
)

## CREATING PROBLEM STATEMENTS
ps_titles = ["How might we make professional development videos more relevant?", "How might we make professional development videos easier to find?", "How might we better represent reality with professional development videos?"]

ps_titles.each do |ps_title|
  idea_stage.problem_statements.create!(
    title: ps_title,
    description: Faker::Lorem.paragraph(4)
  )
end