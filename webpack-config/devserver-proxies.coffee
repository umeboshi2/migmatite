# proxies for devserver
# 
module.exports =
  '/api/*':
    target: 'http://localhost:6543'
    secure: false
  '/rest/v0/*':
    target: 'http://localhost:6541'
    secure: false
  '/hubcal*':
    target: 'http://localhost:6541'
    secure: false
        
