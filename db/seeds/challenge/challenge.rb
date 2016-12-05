challenge = Challenge.create!(
  title: 'The Belonging Challenge',
  headline: "How do we create a sense of belonging for students in school and community?",
  goal: 'creating a sense of belonging',
  video_url: '<script src="//fast.wistia.com/embed/medias/x01uf87566.jsonp" async></script><script src="//fast.wistia.com/assets/external/E-v1.js" async></script><div class="wistia_responsive_padding" style="padding:56.25% 0 0 0;position:relative;"><div class="wistia_responsive_wrapper" style="height:100%;left:0;position:absolute;top:0;width:100%;"><div class="wistia_embed wistia_async_x01uf87566 videoFoam=true" style="height:100%;width:100%">&nbsp;</div></div></div>',
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
  featured: true,
  drawing: "<article class='articleWrapper'>
    <h1>Privacy Policy</h1>
    <p>Last updated: (add date)</p>

    <p>(change: YOUR COMPANY NAME) ('us', 'we', or 'our') operates (change: WEB ADDRESS) (the 'Site'). This page
      informs you of our policies regarding the collection, use and disclosure of Personal Information we receive
      from users of the Site. We use your Personal Information only for providing and improving the Site. By using
      the Site, you agree to the collection and use of information in accordance with this policy.</p>

    <h2> Information Collection And Use</h2>

    <p> While using our Site, we may ask you to provide us with certain personally identifiable information that can
      be used to contact or identify you. Personally identifiable information may include, but is not limited to
      your name ('Personal Information').</p>

    <h2>Communications</h2>
    <p> We may use your Personal Information to contact you with newsletters, marketing or promotional materials and
      other information that (change: LIST YOUR COMMUNICATION METHODS AND DETAILS HERE)</p>

    <h2>Security</h2>

    <p>The security of your Personal Information is important to us, but remember that no method of transmission
      over the Internet, or method of electronic storage, is 100% secure. While we strive to use commercially
      acceptable means to protect your Personal Information, we cannot guarantee its absolute security.</p>
    <h2> Changes To This Privacy Policy</h2>
    <p>This Privacy Policy is effective as of (change: ADD DATE) and will remain in effect except with respect to
      any changes in its provisions in the future, which will be in effect immediately after being posted on this
      page.</p>
    <p>We reserve the right to update or change our Privacy Policy at any time and you should check this Privacy
      Policy periodically. Your continued use of the Service after we post any modifications to the Privacy Policy
      on this page will constitute your acknowledgment of the modifications and your consent to abide and be bound
      by the modified Privacy Policy.</p>
    <p>If we make any material changes to this Privacy Policy, we will notify you either through the email address
      you have provided us, or by placing a prominent notice on our website.</p>

    <h2> Contact Us</h2>
    <p>If you have any questions about this Privacy Policy, please contact us (change: YOUR CONTACT EMAIL)</p>
  </article>"
)

## CREATING DEMO PANEL
challenge.create_panel!(
  about: "Our Challenge Guides are educators and researchers who are passionate about making professional learning the best it can be. They're here to support and synthesize the Redesign Challenge conversation and make sure your voice is heard, your questions are answered and great ideas are shared!",
  user_ids: User.where(admin: false).pluck(:id).sample(8)
)
