challenge = Challenge.create!(
  title: 'The Classroom Video Challenge',
  headline: "Are professional development videos working for you?",
  video_url: 'https://www.youtube.com/watch?v=lvRBFdISNeo',
  remote_banner_url: 'https://s3-us-west-2.amazonaws.com/redesign-challenge-local/documents/bg.png',
  hashtag: 'RDChallenge',
  description: "<h2 class='section-title'>First Step: Share your experience with video for your professional learning</h2><p class='section-description'>Think big and earn an opportunity to attend our July Innovator's Weekend…to make your ideas real.</p>",
  incentive: "Remember, anyone who contributes is eligible for the weekly gift certificate giveaway (<a href='#'>see contest rules</a>)",
  background: "School systems across the country are investing time and money to create and share professional development videos, but are these videos giving us what they need, when we need it? What if we - teachers, coaches and administrators - came together to share our experiences and come up with ideas for how videos can better meet our learning needs?",
  outcome: "The Redesign Challenge fosters a community of dedicated educators who, for this first challenge, will think hard to transform how video is used in professional learning. This is a real opportunity to change how we do things in K-12 education. In the Redesign Challenge, good ideas surface to the top no matter what your position is.",
  help: "There are four ways you can get involved over the course of the Challenge: <b>share</b> your story, <b>contribute</b> ideas for how to improve classroom video, <b>develop</b> those recipes, and <b>try out</b> popular solutions in your classroom. You'll eventually be able to participate in any stage. Ready? Scroll down to click \"Get Started\".",
  cta: 'Want to help improve classroom video?',
  starts_at: Time.now,
  ends_at: 1.month.from_now,
  featured: true
)

## CREATING DEMO PANEL
challenge.create_panel!(
  about: "Our Challenge Guides are educators and researchers who are passionate about making professional learning the best it can be. They're here to support and synthesize the Redesign Challenge conversation and make sure your voice is heard, your questions are answered and great ideas are shared!",
  user_ids: User.where(admin: false).pluck(:id).sample(8)
)
