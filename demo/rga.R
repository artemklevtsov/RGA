library(RGA)

# 1. Set RGA_CONSUMER_ID and RGA_CONSUMER_SECRET environment variables

# 2. Get OAuth2.0 token
ga_token <- get_token()

# 2. Get profiles information
get_profiles(token = ga_token)

# 3. Profile ID
profile.id <- get_profiles(token = ga_token)[1, 1]

# 4. Set query
query <- set_query(profile.id = profile.id)
print(query)

# 5. Get first date
first.date <- get_firstdate(profile.id = profile.id, token = ga_token)

# 6. Get data
# 6.1. Get data with query
get_report(query = query, token = ga_token)
# 6.2 Get data directly
get_report(profile.id = profile.id, token = ga_token)
