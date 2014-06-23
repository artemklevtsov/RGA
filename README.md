# RGA

This package is designed to work with the **API Google Analytics** in **R**.

Key **features**:

* Support for [OAuth 2.0 authorization](https://developers.google.com/accounts/docs/OAuth2);
* Access to following [Google Analytics APIs](https://developers.google.com/analytics/devguides/platform/):
    - [Management API](https://developers.google.com/analytics/devguides/config/mgmt/v3): access configuration data for accounts, web properties, views (profiles), goals and segments;
    - [Core Reporting API](https://developers.google.com/analytics/devguides/reporting/core/v3): query for dimensions and metrics to produce customized reports;
    - [Multi-Channel Funnels Reporting API](https://developers.google.com/analytics/devguides/reporting/mcf/v3): query the traffic source paths that lead to a user's goal conversion;
    - [Metadata API](https://developers.google.com/analytics/devguides/reporting/metadata/v3): access the list of API dimensions and metrics and their attributes;
* Support of the batch processing of the requests (allows to overcome the restriction on the number of rows returned for a single request).

## Installation

**Notice:** Currently the package `RGA` is under development and is not available via a CRAN network.

To install the current version of the `RGA` package can be used the `install_bitbucket` function from `devtools` package:

```R
devtools::install_bitbucket(repo = "rga", username = "unikum")
```

Another method to install the package `RGA` (using the commands in the terminal):

```bash
git clone https://unikum@bitbucket.org/unikum/rga.git
R CMD build rga
R CMD INSTALL rga_*.tar.gz
```

## Preparation

### Obtain OAuth 2.0 credentials to access to the API Google Analytics

Before to start working with the `RGA` package, it is necessary to create a new application in [Google Developers Console](https://console.developers.google.com/) and obtain a **Client ID** and **Client secret** to access the API Google Analytics.

Step by step instructions is below.

1. Creation of a new project (can be skipped if the project already created):
    * Open the page https://console.developers.google.com/project;
    * Click on the **Create Project** red button at the top left of the page;
    * In the pop-up window, enter the name of the project into the **PROJECT NAME** field;
    * Click on **Create** to confirm the creation of the project.
2. Activation of the access to the API Google Analytics:
    * Select the project from the project list on https://console.developers.google.com/project page;
    * Select **APIs & auth** in the left sidebar;
    * In the **APIs** tab, click on the **OFF** button to activate **Analytics API** (ensure that instead of `OFF` appeared `ON`).
3. Creating a new application:
    * In the left sidebar, select **APIs & auth** and then **Credentials** sub-paragraph;
    * Click on the **Create new Client ID** button on the left side of the page;
    * In the pop-up window, select **Installed application** from the APPLICATION TYPE list and **Other** from INSTALLED APPLICATION TYPE list.
    * Click on the **Create Client ID** button to confirm the creation of the application.
4. Obtaining Client ID and Client secret:
    * Select the project from the project list on the https://console.developers.google.com/project page;
    * In the left sidebar, select **APIs & auth** and then **Credentials** sub-paragraph;
    * In the **Client ID for native application** table, copy the values of the following fields: **Client ID** and **Client secret**.

You can return to the Google Developers Console at any time to view the **client ID** and **client secret** on the Client ID for native application section on Credentials page.

## Working with the package

### Obtain an access token

Before to exercise any requests to API, it's necessary to perform authorization and to obtain access token. It can be done with the following command:

```R
authorize(client.id = "My_Client_ID", client.secret = "My_Client_secret")
```

After executing this command, a web browser will be opened with a page of query of confirmation of access permission to the data Google Analytics. It's necessary to authorize with your own **Google account** and confirm the authorization to access the Google Analytics data. Note, the package `RGA` requests access of **read-only** data.

When the `authorize` is used, the `GAToken` variable is created in the separate `TokenEnv` environment which not visible for user. So, there is no need to pass every time the `token` argument to any function which require authorisation.

Access token can also be stored in a variable and passed as argument for functions, which make requests to the API Google Analytics. This can be useful if you work with several accounts at the same time.

```R
ga_token <- authorize(client.id = "My_Client_ID", client.secret = "My_Client_secret")
get_profiles(token = ga_token)
```

If the `cache` argument was ​​assigned the `TRUE` (default) and  the `httr_oauth_cache` option was not changed, then after successful authorization the `.httr-oauth` file with access data to Google API will be created in the current working directory. The `.httr-oauth` file will be used between sessions, i.e. at a subsequent call to the `authorize`  function, authorization is no longer required. With using the `cache` argument you can also cancel the creation of the file (`FALSE` value) or specify an alternate path to the file storage (for that necessary to explicitly specify the path and file name).

Note: Besides of the explicit specifying the `client.id` and `client.secret` arguments, their values ​​can be defined via environment variables: `RGA_CONSUMER_ID` and `RGA_CONSUMER_SECRET`. In this case, the specifying the `client.id` and `client.secret` arguments at call `authorize` function is not required.

Setting the environment variables is different for various operating systems, so the user should refer to the relevant reference materials (view the list of references at the end of this manual). Also, there is a setup method of the environment variables when running R-sessions using the `.Renviron` files in the user's working or home directory. Contents of the file might look like this:

```txt
RGA_CONSUMER_ID="My_Client_ID"
RGA_CONSUMER_SECRET="My_Client_secret"
```

Environment variables can also be set directly from R-session using the `Sys.setenv` function. For instance:

```R
Sys.setenv(RGA_CONSUMER_ID = "My_Client_ID", RGA_CONSUMER_SECRET = "My_Client_secret")
```

 This string can be added to the file `.Rprofile` in the user's current оr home directory, to set automatically these variables when the R-сессион starts.

### Obtaining the access to the API configuration

To access the API Google Analytics configuration, package `RGA` provides the following functions: `get_accounts`, `get_webproperties`, `get_profiles`, `get_goals` и `get_segments`. Each of these functions returns a table of data (`data.frame`), with the relevant content.

Let's review these functions in details.

* `get_accounts` - getting the list of accounts to which the user has access;
* `get_webproperties` - getting a list of web propertys (Web Properties), to which the user has access;
* `get_profiles` - getting a list of web propertys (Web Properties) and views (Profiles) sites to which the user has access;
* `get_goals` - obtaining a list of goals to which the user has access;
* `get_segments` - obtaining a list of segments to which the user has access;

For the functions such as `get_webproperties`, `get_profiles` and `get_goals`, can be specified the additional arguments such as `account.id`, `webproperty.id` or `profile.id`  which is required to obtain the information for specific account, resource or profile (view the help pages for the corresponding functions). Example of obtaining the information on all submissions is available to the user:

```R
get_profiles()
```

### Obtaining access to the metadata of API reports

When working with the API reports, sometimes necessary to obtain background information about these or other query parameters to the API. To obtain a list of all the metrics (metrics) and measurements (dimensions)`RGA` package provides a  a set of data (dataset) `ga`, which is available after loading the package.

Access to a set of data is exercised similarly as access to any object in R - variable name:

```R
ga
```

The set of data `ga` consists the the following columns:

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
* `premiumMaxTemplateIndex`      - if the parameter contains a numeric index, a maximum index for the parameter.

There are several examples of  usage the metadata Google Analytics API.

List of all outdated and replacing their parameters:

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

### Obtaining an access to API reports

To access to API reports is used `get_report` function. In this case, the parameters for a query to Google Analytics can be passed whether directly through arguments of the `get_report`function or through an intermediate `GAQuery`object which is created with the `set_query`function.

The following parameters are available for queries to the API reports:

* `profile.id` - profile ID (submission) Google Analytics. Can be obtained using the `get_progiles` or via the web interface Google Analytics.
* `start.date` - date started collecting data in the format YYYY-MM-DD. Also, allowed values, such as "today", "yesterday", "ndaysAgo", where `n` is the number of days.
* `end.date` - дата окончания сбора данных в формате YYYY-MM-DD. Also, allowed values, such as "today", "yesterday", "ndaysAgo", where `n` is the number of days.
* `metrics` -  comma-separated list of values ​​of metrics (metrics), for example, "ga:sessions,ga:bounces". The number of metrics can not exceed 10 indicators for a single request.
* `dimensions` - comma-separated list of values ​​of measurements (dimensions), for example, "ga:browser,ga:city". The number of dimensions can not exceed 7 measurements at a single request.
* `sort` - comma-separated list of metrics (metrics) and measurements (dimensions) determining the order and direction of sorting data. Reverse the sort order is defined by `-` before the relevant metric.
* `filters` - comma-separated list of filters of metrics (metrics) and measurements (dimensions), that will be imposed when selecting data.
* `segment` - segments that will be used when retrieving data.
* `start.index` - index of the first returned result (line number).
* `max.results` - maximum number of fields (rows) of the returned results.

The following arguments:`profile.id`, `start.date`, `end.date` and `metrics` are mandatory. Notice that all arguments must be a character strings of unit length. The exception is `profile.id` which can be as a character string, as the number.

Besides, function `get_report` supports the following arguments:

* `type` - type of report: "ga" - basic report (core report) and "mcf" - report of multichannel sequences (multi-channel funnels).
* `query` - object of class `GAQuery` which contains the query parameters. Can be obtained using the `set_query` function.
* `token` - object of class `Token2.0` which contains data about the token of access. Can be obtained using the `authorize` function.
* `batch` - logical argument which includes a mode of batch processing of queries. It is required if the number of fields (rows) exceeds 10000 (restriction Google).
* `messages` - logical argument which includes displaying of additional messages during the data request.

Notice, if you use the metrics (metrics) and measurements (dimensions) of the report of multichannel sequences, for instance, "mcf:totalConversions", then the argument `type` should be set value "mcf".

Example of data obtaining for the last 30 days:

```R
ga_data <- get_report(profile.id = XXXXXXXX, start.date = "30daysAgo", end.date = "yesterday",
                      metrics = "ga:users,ga:sessions,ga:pageviews")
```

The same effect can be achieved through intermediate variable `query`:

```R
query <- set_query(profile.id = XXXXXXXX, start.date = "30daysAgo", end.date = "yesterday",
                   metrics = "ga:users,ga:sessions,ga:pageviews")
print(query)
ga_data <- get_report(query)
```

The variable `ga_data` is a data table (`data.frame`) and contains as columns those metrics (metrics)and measurements (dimensions) that were defined in the query.

Notice, after creating the object `query`, we can change its parameters, setting them values ​​analogically to lists:

```R
query$dimensions <- "ga:date"
query$filters <- "ga:sessions > 1000"
print(query)
```

Remove one or another value of `query` object might be by assigning it a value of `NULL`:

```R
query$filters <- NULL
print(query)
```

Sometimes it is necessary to obtain the data for the entire monitoring period through service Google Analytics. For these purposes, the package `RGA` provides the function `get_firstdate` which takes as an argument a charming profile ID (submission):

```R
first_date <- get_firstdate(profile.id = XXXXXXXX, token = token)
```

Now we can use the variable `first_date` as the argument `start.date` when call the `get_report` function:

```R
ga_data <- get_report(profile.id = XXXXXXXX, start.date = first_date, end.date = "yesterday",
                      metrics = "ga:users,ga:sessions,ga:pageviews")
```


## References

* [Google Developers Console](https://console.developers.google.com/project);

### Google Analytics API

* [Management API Reference](https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/)
* [Core Reporting API Reference Guide](https://developers.google.com/analytics/devguides/reporting/core/v3/reference)
* [Multi-Channel Funnels Reporting API Reference Guide](https://developers.google.com/analytics/devguides/reporting/mcf/v3/reference)
* [Metadata API Reference](https://developers.google.com/analytics/devguides/reporting/metadata/v3/reference/)
* [Configuration and Reporting API Limits and Quotas](https://developers.google.com/analytics/devguides/reporting/metadata/v3/limits-quotas)

### Environment variables

* [Setting environment variables in Windows XP](http://support.microsoft.com/kb/310519)
* [Setting environment variables in earlier versions of OSX](https://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPRuntimeConfig/Articles/EnvironmentVars.html)
* [Setting environment variables in Ubuntu Linux](https://help.ubuntu.com/community/EnvironmentVariables)