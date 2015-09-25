library(httr)
library(ggplot2)

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
steps$value <- as.numeric(as.character(steps$value))
steps$dateTime <- as.Date(steps$dateTime)

#Sleep Series
resp = GET('https://api.fitbit.com/1/user/-/sleep/minutesAsleep/date/2015-01-19/today.json', gtoken)
d <- content(resp)
sleep <- do.call(rbind.data.frame, d$`sleep-minutesAsleep`)
sleep$value <- as.numeric(as.character(steps$value))
sleep$dateTime <- as.Date(steps$dateTime)

#Daily Sleep
sleepDetail <- data.frame()

days = seq(as.Date("2015-02-23"), as.Date("2015-09-25"), by="1 day")

for(day in days){
    x = as.Date(day, origin="1970-01-01") 
    print( x)
    resp = GET(paste('https://api.fitbit.com/1/user/-/sleep/date/',x,'.json', sep=''), gtoken)
    d <- content(resp)
    # print(length(d[1]$sleep[[1]]))
    if( length(d[1]$sleep[[1]]) == 17){
        minuteData <- d[1]$sleep[1][[1]][9]$minuteData
        d[1]$sleep[1][[1]][9] <- NULL
        
        tryCatch({sleepDetail <- rbind(sleepDetail, as.data.frame(d))},
                 error=function(cond) {return(0)})
    }
}

resp = GET(paste('https://api.fitbit.com/1/user/-/sleep/date/2015-09-23.json', sep=''), gtoken)
t1 <-  content(resp)

resp = GET(paste('https://api.fitbit.com/1/user/-/sleep/date/2015-01-23.json', sep=''), gtoken)
t2 <-  content(resp)


# awakeCount <-d[1]$sleep[1][[1]][1]$awakeCount
# duration <-  d[1]$sleep[1][[1]][5]$duration
# efficiency <- d[1]$sleep[1][[1]][6]$efficiency
# restless <- d[1]$sleep[1][[1]][14]$restlessCount
# minutesAsleep <- d[1]$sleep[1][[1]][11]$minutesAsleep
# minutesAwake <- d[1]$sleep[1][[1]][12]$minutesAwake
# restlessDuration <- d[1]$sleep[1][[1]][15]$restlessDuration
