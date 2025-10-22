# frozen-string-literal: true

configure do |g|
  g.root '/home/username/code'

  g.identity user: 'username', host: 'github.com',  name: 'Real Name',
             email: '1234567+username@users.noreply.github.com',
             file: 'id_username_github.com_ed25519.pub'
  g.identity user: 'other', host: 'github.com',
             email: '8901234+other@users.noreply.github.com',
             file: 'id_other_github.com_ed25519.pub',
             define_matcher: false

  g.match host('github.com') | project(/project|names|to|match/),
          to: 'other@github.com'
  g.match __default__, to: 'username@github.com'
end
