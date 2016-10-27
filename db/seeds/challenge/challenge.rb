challenge = Challenge.create!(
  title: 'The Belonging Challenge',
  headline: "How do we create a sense of belonging for students in school and community?",
  goal: 'creating a sense of belonging',
  video_url: 'https://vimeo.com/185424174',
  remote_banner_url: 'https://s3-us-west-2.amazonaws.com/sevenzo-production/challenge/1/Belonging_hero714.png',
  hashtag: 'edubelong',
  description: "<h2 class='section-title'>Why this challenge matters</h2>

    <p class='section-description'>Belonging is associated with many positive life outcomes such as a greater sense of well-being and happiness, better stress management, greater health and even lower mortality rates. On the other hand, a lack of belongingness can impair learning and performance. <strong>This challenge will focus on the powerful role that belonging plays in academic success.</strong> We will work together to find the best approaches to creating a sense of belonging for all students so they can learn and thrive in school.</p>

    <div class='row' style='margin-top:1em;margin-bottom:1em;'>
    <div class='col-sm-6'>
    <img src='https://s3-us-west-2.amazonaws.com/sevenzo-test/block_3.png' width='100%'/>
    </div>
    <div class='col-sm-6'>
    <img src='https://s3-us-west-2.amazonaws.com/sevenzo-test/block_4.png' width='100%'/>
    </div>
    </div>

    <h4 class='text-center text-underline'><a href='https://medium.com/@sevenzo' target='_blank'>Read more about belonging on our blog <i class='fa fa-long-arrow-right'></i></a></h4>

    <hr class='break'>

    <h2 class='section-title'>Our Challenge will go through four stages</h2>

    <p class='section-description'>We welcome all educators including classroom teachers, teacher leaders, coaches, administrators, support staff and out of school mentors to participate!</p>",
  incentive: "",
  background: "This challenge will focus on the powerful role that belonging plays in academic success. We will work together to find the best approaches to creating a sense of belonging for all students so they can learn and thrive in school.",
  outcome: "Our collective goal is to source as many promising belonging practices as possible and then work with each other to remix them across as many locations as possible.",
  help: "There are four ways you can get involved over the course of the Challenge: <b>share</b> your story, <b>contribute</b> ideas on how to improve classroom video, <b>develop</b> those recipes, and <b>try out</b> popular solutions in your classroom. You'll eventually be able to participate in any stage. Ready? Scroll down to click \"Join the Conversation\"!",
  cta: 'We want to hear from you.',
  comment_placeholder: 'Belonging to me is...',
  starts_at: Time.now,
  ends_at: 1.month.from_now,
  featured: true
)

## CREATING DEMO PANEL
challenge.create_panel!(
  about: "Our Challenge Guides are educators and researchers who are passionate about making professional learning the best it can be. They're here to support and synthesize the Redesign Challenge conversation and make sure your voice is heard, your questions are answered and great ideas are shared!",
  user_ids: User.where(admin: false).pluck(:id).sample(8)
)
