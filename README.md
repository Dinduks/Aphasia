# How to install
## The backend API
`bundle install`, then run the app as a rack one or with
`bundle exec rackup -p 4567`.

## The frontend UI
* Put *frontend/*'s content wherever your want
* Copy *js/config.js-dist* to *js/config.js*: `cp js/config.js{-dist,}`
* Setup the application by editing *js/config.js*

# How to run the app
You need to run the frontebd UI in a server in order to avoid the same origin
policy block.

     cd frontend && python -m SimpleHTTPServer 8001

# How to run the tests

    bundle exec rspec
