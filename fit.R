library(httr)

source('config.R')

token_url = 'https://api.fitbit.com/oauth/request_token'
access_url = 'https://api.fitbit.com/oauth/access_token'
auth_url = 'https://www.fitbit.com/oauth/authorize'

myapp = oauth_app(app, key, secret)
fb_ep = oauth_endpoint(token_url, auth_url, access_url)
token = oauth1.0_token(fb_ep, myapp)
gtoken = config(token = token)

#Steps BY Day
resp = GET('https://api.fitbit.com/1/user/-/activities/steps/date/2015-01-19/today.json', gtoken)
d <- content(resp)
steps <- do.call(rbind.data.frame, d$`activities-steps`)


