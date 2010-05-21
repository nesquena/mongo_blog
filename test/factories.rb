Factory.define :account do |u|
  u.name 'john'
  u.surname 'smith'
  u.email 'agent@smith.com'
  u.password 'testy'
  u.password_confirmation 'testy'
  u.role 'admin'
end

Factory.define :post do |u|
  u.title 'This is my first post!'
  u.body 'Hello World!'
  u.tags ['first','post','ftw']
end
