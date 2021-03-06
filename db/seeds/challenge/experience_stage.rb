challenge = Challenge.find(1)
challenge.update_column(:active_stage, 'experience')

## CREATE EXPERIENCE STAGE
experience_stage = challenge.create_experience_stage!(
  title: "Share what you know.", 
  description: "Tell your story. What's been your experience with professional learning video?",
  incentive: "Participate and you could win a $50 gift card. Those with the best ideas go to Innovator's Weekend July 31-August 2. (<a href='#'>see contest rules</a>)",
  active: true,
  public: true, 
  starts_at: Time.now, 
  ends_at: 5.days.from_now
)

## CREATING THEMES
themes = ["Why is it hard to find good professional development videos?", "What is your experience with professional development video?", "What is working well in professional development?"]

themes.each{ |theme| experience_stage.themes.create!(title: theme) } 