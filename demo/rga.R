library(RGA)

# 1. Set RGA_CONSUMER_ID and RGA_CONSUMER_SECRET environment variables

# 2. Get OAuth2.0 token
ga_token <- get_token()

# 2. Get profiles information
get_profiles(token = ga_token)

# 3. Profile ID
profile.id <- get_profiles(token = ga_token)[1, 1]

# 4. Get first date
first.date <- get_firstdate(profile.id = profile.id, token = ga_token)

# 5. Get data
get_report(profile.id = profile.id, token = ga_token)
