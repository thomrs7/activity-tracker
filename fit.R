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
write.csv2(steps, file='steps.csv')

#Sleep Series
resp = GET('https://api.fitbit.com/1/user/-/sleep/minutesAsleep/date/2015-01-19/today.json', gtoken)
d <- content(resp)
sleep <- do.call(rbind.data.frame, d$`sleep-minutesAsleep`)
sleep$value <- as.numeric(as.character(steps$value))
sleep$dateTime <- as.Date(steps$dateTime)
write.csv2(sleep, file='sleep.csv')

#Daily Sleep
sleepDetail <- data.frame()

days = seq(as.Date("2015-08-17"), as.Date("2015-09-25"), by="1 day")

for(day in days){
    x = as.Date(day, origin="1970-01-01") 
    print( x)
    resp = GET(paste('https://api.fitbit.com/1/user/-/sleep/date/',x,'.json', sep=''), gtoken)
    d <- content(resp)
    # print(length(d[1]$sleep[[1]]))
    tryCatch({
    if( length(d[1]$sleep[[1]]) == 17){
        minuteData <- d[1]$sleep[1][[1]][9]$minuteData
        d[1]$sleep[1][[1]][9] <- NULL
        
            print(d[1]$sleep)
            sleepDetail <- rbind(sleepDetail, as.data.frame(d))
            }
        },
            error=function(cond) {return(0)})
}

write.csv2(sleepDetail, file='sleepDetail.csv')

sleepDetail$sleep.minutesAsleep <- as.numeric(as.character(sleepDetail$sleep.minutesAsleep))
sleepDetail$sleep.dateOfSleep <- as.Date(sleepDetail$sleep.dateOfSleep)

ggplot(sleepDetail, aes(x=sleep.dateOfSleep, y=sleep.minutesAsleep)) + 
    geom_bar(stat="identity", position = 'dodge', aes(fill=sleep.minutesAsleep)) +
    scale_fill_gradientn(colours= viridis(12)) + 
    geom_point(data=sleepDetail, aes(x=sleep.dateOfSleep, y=sleep.restlessDuration,
                                     color=sleep.restlessCount), size=3) 
    



# awakeCount <-d[1]$sleep[1][[1]][1]$awakeCount
# duration <-  d[1]$sleep[1][[1]][5]$duration
# efficiency <- d[1]$sleep[1][[1]][6]$efficiency
# restless <- d[1]$sleep[1][[1]][14]$restlessCount
# minutesAsleep <- d[1]$sleep[1][[1]][11]$minutesAsleep
# minutesAwake <- d[1]$sleep[1][[1]][12]$minutesAwake
# restlessDuration <- d[1]$sleep[1][[1]][15]$restlessDuration
