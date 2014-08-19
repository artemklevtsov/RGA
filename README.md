# RGA

This package is designed to work with the [**API Google Analytics**](https://developers.google.com/analytics) in [**R**](http://www.r-project.org/). You can use this package to retrieve R `data.frame` from **Google Analytics** data.

Key features:

* [OAuth 2.0](https://developers.google.com/accounts/docs/OAuth2) authorization;
* Access to the following [Google Analytics APIs](https://developers.google.com/analytics/devguides/platform/):
    - [Management API](https://developers.google.com/analytics/devguides/config/mgmt/v3): access to configuration data for accounts, web properties, views (profiles), goals and segments;
    - [Core Reporting API](https://developers.google.com/analytics/devguides/reporting/core/v3): query for dimensions and metrics to produce customized reports;
    - [Multi-Channel Funnels Reporting API](https://developers.google.com/analytics/devguides/reporting/mcf/v3): query the traffic source paths that lead to a user's goal conversion;
    - [Real Time Reporting API](https://developers.google.com/analytics/devguides/reporting/realtime/v3): report on activity occurring on your property at the moment;
    - [Metadata API](https://developers.google.com/analytics/devguides/reporting/metadata/v3): access the list of API dimensions and metrics and their attributes;
* Access to all the accounts which the user has access to;
* API responses is converted directly into R as a `data.frame`;
* Auto-pagination to return more than 10,000 rows of the results by combining multiple data requests.

## Installation

To install the latest release version from CRAN with:

```R
install.packages("RGA")
```

To install the development version the `install_bitbucket` function from `devtools` package can be used:

```R
devtools::install_bitbucket(repo = "rga", username = "unikum")
```

Another method to install the package `RGA` (using the command line):

```bash
git clone https://unikum@bitbucket.org/unikum/rga.git
R CMD build rga
R CMD INSTALL rga_*.tar.gz
```

## Preparation

### Obtain OAuth 2.0 credentials to get access to the Google Analytics API

Before you start working with the `RGA` package, you need to create a new application in [Google Developers Console](https://console.developers.google.com/) and obtain a **Client ID** and **Client secret** to access to the Google Analytics API.

Step by step instructions are as follows:

1. Creation of a new project (can be skipped if the project is already created):
    * Open the page https://console.developers.google.com/project;
    * Click on **Create Project** red button at the top left of the page;
    * Enter the name of the project into the **PROJECT NAME** field in the pop-up window;
    * Click **Create** to confirm the creation of the project.
2. Enabling access to the Google Analytics API:
    * Select your project from the project list on https://console.developers.google.com/project page;
    * Select **APIs & auth**  in the left sidebar;
    * Click **OFF** for activation **Analytics API** (ensure that `OFF` turned to `ON`) in the **APIs** tab.
3. Creating a new application:
    * Select **APIs & auth** and then **Credentials** sub-menu in the left sidebar;
    * Click **Create new Client ID** on the left side of the page;
    * Select **Installed application** from the APPLICATION TYPE list and **Other** from INSTALLED APPLICATION TYPE list in the pop-up window.
    * Click on the **Create Client ID** button to confirm the creation of the application.
4. Obtaining Client ID and Client secret:
    * Select the project from the project list on the https://console.developers.google.com/project page;
    * Select **APIs & auth** and then **Credentials** sub-menu in the left sidebar;
    * Copy the values of the following fields: **Client ID** and **Client secret** in the **Client ID for native application** table.

You can return to the Google Developers Console at any time to view the **Client ID** and **Client secret** on the Client ID for native application section on Credentials page.

## Usage

### Overview

Once you have the package loaded, there are 3 steps you need to use to get data from **Google Analytics**:

1. Authorize this package to access your Google Analytics data with the `authorize` function.
1. Determine the profile ID which you want to get access to with the `get_profiles` function.
1. Get the results from the API with one of these functions: `get_ga`, `get_mcf` or `get_rt`.

### Obtain an access token

Before you send any requests to GA API, it's necessary to perform authorization and to obtain access token. It can be done with the following command:

```R
authorize(client.id = "My_Client_ID", client.secret = "My_Client_secret")
```

After calling this function first time, a web browser will be opened. First entrance with a **Google Account** confirms access to the Google Analytics data. Note that the package requests access for the **read-only** data.

When the `authorize` function is used, the `GAToken` variable is created in the separate `TokenEnv` environment which not visible for user. So, there is no need to pass every time the `token` argument to any function which requires authorization.

Access token can also be stored in a variable and passed as the argument to the functions which request the API Google Analytics. It can be useful when you are working with several accounts at the same time.

```R
ga_token <- authorize(client.id = "My_Client_ID", client.secret = "My_Client_secret")
get_profiles(token = ga_token)
```

When the `cache` argument is ​​assigned the `TRUE` (default) and  the `httr_oauth_cache` option is not changed, then after successful authorization the `.httr-oauth` file with access data to Google API will be created in the current working directory. The `.httr-oauth` file is used between sessions, i.e. at a subsequent call to the `authorize`  function and authorization in the browser tab is not required. Using the `cache` argument you can also cancel the creation of the file (`FALSE` value) or specify an alternate path to the file storage (in this case It is necessary to specify the path and file name explicitly).

Note: Besides the explicit specifying of the `client.id` and `client.secret` arguments, their values ​​can be defined via environment variables: `RGA_CONSUMER_ID` and `RGA_CONSUMER_SECRET`. In this case, specifying of the `client.id` and `client.secret` arguments is not required for calling `authorize` function.

Setting the environment variables is different for various operating systems. The user should refer to the relevant reference materials (view the list of references at the end of this manual). Also there is a setup method of the environment variables when running R sessions using the `.Renviron` files in the user's working or home directory. Contents of the file might look like this:

```txt
RGA_CONSUMER_ID="My_Client_ID"
RGA_CONSUMER_SECRET="My_Client_secret"
```

Environment variables can also be set directly from R session using the `Sys.setenv` function. For instance:

```R
Sys.setenv(RGA_CONSUMER_ID = "My_Client_ID", RGA_CONSUMER_SECRET = "My_Client_secret")
```

This string can be added to the file `.Rprofile` in the user's current оr home directory in order to set these variables automatically when the R session starts.

### Obtain the access to the Management API

To access the Management API Google Analytics package `RGA` provides the following functions: `get_accounts`, `get_webproperties`, `get_profiles`, `get_goals` и `get_segments`. Each of these functions return a table of data (`data.frame`), with the relevant content.

Let's review these functions in details:

* `get_accounts` - getting the list of accounts which the user has access to;
* `get_webproperties` - getting a list of web properties (Web Properties) which the user has access to;
* `get_profiles` - getting a list of web properties (Web Properties) and views (Profiles) sites which the user has access to;
* `get_goals` - obtaining a list of goals which the user has access to;
* `get_segments` - obtaining a list of segments which the user has access to;

The functions such as `get_webproperties`, `get_profiles` and `get_goals` can be specified with the additional arguments such as `account.id`, `webproperty.id` or `profile.id`  which are required to obtain the information for specific account, resource or profile (view the help pages for the corresponding functions). This is an example of obtaining the information on all views (profiles):

```R
get_profiles()
```

### Obtain an access to the Reporting API

To access the Reporting API Google Analytics package `RGA` provides the following functions:

* `get_ga` - returns Analytics data for a view (profile);
* `get_mcf` - returns Analytics Multi-Channel Funnels data for a view (profile);
* `get_rt` - returns real time data for a view (profile).

The following parameters are available for queries to the API reports:

* `profile.id` - profile (view) ID. Can be obtained using the `get_profiles` or via the web interface Google Analytics;
* `start.date` - the start date for collecting data formatted as YYYY-MM-DD. Also values such as "today", "yesterday", "ndaysAgo" are allowed, where n is the number of days;
* `end.date` - the end date for collecting data formatted as YYYY-MM-DD. Also values such as "today", "yesterday", "ndaysAgo" are allowed, where n is the number of days;
* `metrics` -  comma-separated list of values ​​of metrics (metrics), for example, `"ga:sessions,ga:bounces"`. The number of metrics cannot exceed 10 indicators for a single request;
* `dimensions` - comma-separated list of values ​​of measurements (dimensions), for example, `"ga:browser,ga:city"`. The number of dimensions cannot exceed 7 measurements at a single request;
* `sort` - comma-separated list of metrics (metrics) and measurements (dimensions) which determine the order and direction of sorting data. The reverse sort order is defined by “-“ before the relevant metric;
* `filters` - comma-separated list of metric (metrics) and measurement (dimensions) filters that are imposed when data is selected;
* `segment` - segments that are used when retrieving data. Can be obtained using the `get_segments` or via the web interface Google Analytics;
* `start.index` - index of the first returned result (line number);
* `max.results` - maximum number of fields (rows) of the returned results;
* `token` - object of class `Token2.0` which contains data with a valid authorization data. Can be obtained using the `authorize` function;
* `messages` - logical argument which includes displaying of additional messages during the data request.

The following arguments: `profile.id`, `start.date`, `end.date` and `metrics` are required for `get_ga` and `get_mcf` (`get_rt` requires only `profile.id` and `metrics`). Notice that all arguments must be character strings of unit length. The exception is `profile.id` which can be both character string and numeric.

This is an example of data obtaining for the last 30 days:

```R
ga_data <- get_ga(profile.id = XXXXXXXX, start.date = "30daysAgo", end.date = "yesterday",
                  metrics = "ga:users,ga:sessions,ga:pageviews")
```

Sometimes it is necessary to obtain the data for the entire monitoring period through service Google Analytics. For these purposes the package `RGA` provides the function `get_firstdate` which takes a charming profile ID (submission) as an argument:

```R
first_date <- get_firstdate(profile.id = XXXXXXXX)
```

Now we can use the variable `first_date` as the argument `start.date` when we call the `get_ga` function:

```R
ga_data <- get_ga(profile.id = XXXXXXXX, start.date = first_date, end.date = "yesterday",
                  metrics = "ga:users,ga:sessions,ga:pageviews")
```

#### Sampled data

If at least one of the following thresholds is met Analytics samples data accordingly:

* 1,000,000 maximum unique dimension combinations for any type of query;
* 500,000 maximum sessions for special queries where the data is not already stored.

In order to avoid this, you can split the query into multiple small queries (day-by-day). You can get this day-by-day data by using the following code:

```R
dates <- seq(as.Date("2012-01-01"), as.Date("2012-02-01"), by = "days")
ga_data <- aggregate(. ~ keyword, FUN = sum,
                     data = do.call(rbind, lapply(dates, function(d) {
                       get_ga(profile.id = XXXXXXXX, start.date = d, end.date = d,
                       metrics = "ga:sessions", dimensions = "ga:keyword",
                       filter = "ga:medium==organic;ga:keyword!=(not provided);ga:keyword!=(not set)")})))
```

Note: a formula in `aggregate` function should include all Google Analyitcs dimensions without prefix ("ga" or "mcf").

### Obtain access to the Metadata API

When working with the API reports it is sometimes necessary to obtain background information about these or other query parameters to the API. To obtain a list of all the metrics (metrics) and measurements (dimensions)`RGA` package provides a set of data (dataset) `ga`, which is available after loading the package.

An access to a set of data can be done in the same way as access to any object in R - variable name:

```R
ga
```

The set of data `ga` consists of the following columns:

* `id` - the parameter code name (metric or dimension) (used for queries);
* `type` - parameter type: metric (METRIC) or dimension (DIMENSION);
* `dataType` - data type: STRING, INTEGER, PERCENT, TIME, CURRENCY, FLOAT;
* `group` - group of parameters (ex. User, Session, Traffic Sources);
* `status` - status: actual (PUBLIC) or outdated (DEPRECATED);
* `uiName` - parameter name (not used for queries);
* `description` - parameter description;
* `allowedInSegments` - whether the parameter can be used in the segments;
* `replacedBy` - name of the replacement parameter, if the parameter is deprecated;
* `calculation` - formula of calculating the parameter value, if the parameter is calculated based on other parameters;
* `minTemplateIndex` - if the parameter contains a numeric index, the minimum parameter index;
* `maxTemplateIndex` - if the parameter contains a numeric index, the maximum parameter index;
* `premiumMinTemplateIndex` - if the parameter contains a numeric index, a minimum index for the parameter;
* `premiumMaxTemplateIndex` - if the parameter contains a numeric index, a maximum index for the parameter.

There are several examples of usage the metadata Google Analytics API.

List of all outdated parameters and those ones which were replaced:

```R
subset(ga, status == "DEPRECATED", c(id, replacedBy))
```

List of all parameters from certain group:

```R
subset(ga, group == "Traffic Sources", c(id, type))
```

List of all calculated parameters:

```R
subset(ga, !is.na(calculation), c(id, calculation))
```

List of all parameters allowed in segments:

```R
subset(ga, allowedInSegments, id)
```

`RGA` package also provide the shiny demo app to access `ga` dataset:

```R
show_dimsmets(ga)
```

## References

### Google Analytics API

* [Google Developers Console](https://console.developers.google.com/project)
* [Management API Reference](https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/)
* [Core Reporting API Reference Guide](https://developers.google.com/analytics/devguides/reporting/core/v3/reference)
* [Multi-Channel Funnels Reporting API Reference Guide](https://developers.google.com/analytics/devguides/reporting/mcf/v3/reference)
* [Metadata API Reference](https://developers.google.com/analytics/devguides/reporting/metadata/v3/reference/)
* [Configuration and Reporting API Limits and Quotas](https://developers.google.com/analytics/devguides/reporting/metadata/v3/limits-quotas)

### Environment variables

* [Setting environment variables in Windows XP](http://support.microsoft.com/kb/310519)
* [Setting environment variables in earlier versions of OSX](https://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPRuntimeConfig/Articles/EnvironmentVars.html)
* [Setting environment variables in Ubuntu Linux](https://help.ubuntu.com/community/EnvironmentVariables)