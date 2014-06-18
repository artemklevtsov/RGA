# RGA

This package is designed to work with the **API Google Analytics** in **R**.

Key **features**:

* Support for OAuth 2.0 authentication;
* Support Google Analytics APIs:
    - Access to the Management API (including accounts information, profiles, goals, segments);
    - Access to the Core Reporting API and the Multi-Channel Funnels Reporting API;
    - Access to the Metadata API.
* Support of the batch processing of the requests (allows to overcome the restriction on the number of rows returned for a single request).

## Installation

Notice: Currently the package `RGA` is in development and is not available via a CRAN network.

`RGA` package can be installed from the git-repository with the `install_bitbucket` function from `devtools` package:

```R
devtools::install_bitbucket(repo = "rga", username = "unikum")
```

If you know GIT and R CMD build, here is another way:

```bash
git clone https://unikum@bitbucket.org/unikum/rga.git
R CMD build rga
R CMD INSTALL rga_*.tar.gz
```

## Preparation

### Obtaining the keys to access to the API Google Analytics

Before start working with the `RGA` package, it is necessary to create a new application in [Google Developers Console](https://console.developers.google.com/) and obtain a **Client ID** and **Client secret** to access the API Google Analytics.

Step by step instructions is below.

1. Create a new project:
    * Open the page https://console.developers.google.com/project;
    * Click on the **Create Project** red button at the top left of the page;
    * In the pop-up window, enter the name of the project into the **PROJECT NAME** field;
    * Click on **Create** to confirm the creation of the project.
2. Activation of the access to the API Google Analytics:
    * Select the project from the project list on https://console.developers.google.com/project page;
    * Select **APIs & auth** in the left sidebar;
    * In the **APIs** tab, click on the **OFF** button to activate **Analytics API**.
3. Creating a new application:
    * In the left sidebar, select **APIs & auth** and **Credentials** sub-paragraph;
    * Click on the **Create new Client ID** button on the left side of the page;
    * In the pop-up window, select **Installed application** from the APPLICATION TYPE list and **Other** from INSTALLED APPLICATION TYPE list.
    * Click on the **Create Client ID** button to confirm the creation of the application.
4. Obtaining Client ID and Client secret:
    * Select the project from the project list on the https://console.developers.google.com/project page;
    * In the left sidebar, select **APIs & auth** and **Credentials** sub-paragraph;
    * In the **Client ID for native application** table, copy the values of the following fields: **Client ID** and **Client secret**.

## Working with the package

### Obtaining an access token

Authorization and obtaining the access token is necessary before implementing any requests to API. It can be done with the following command:

```R
token <- get_token(client.id = "My_Client_ID", client.secret = "My_Client_secret")
```

Note: The values of Client.id and client.secret arguments can be defined via the following environment variables: `RGA_CONSUMER_ID` and `RGA_CONSUMER_SECRET`. In this case, it is not necessary to specify the `client.id` and `client.secret` arguments when calling the `get_token` function.

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

After calling the function `get_token`, the browser is opened and page with confirmation of permission to access to the Google Analytics data is displayed. You need to authorize with your **Google account** and confirm the permission to access to the Google Analytics data. Note: the package `RGA` requests access to **read-only** data. 

If the arguments were used by default and the parameter `httr_oauth_cache` wasn't changed, after successful authorization the `.httr-oauth` file will be created in the working directory with data to access to the Google API, which will be used between sessions. Also, possible to cancel the file creation using the argument `cache` (meaning `FALSE`) or specify an alternate path to the file storage (necessary to specify the path and file name).

The obtained `token` variable will be used in all requests to the API Google Analytics, which require user authentication.

### Obtaining the access to the API configuration

To access the API Google Analytics configuration, package `RGA` provides the following functions: `get_accounts`, `get_webproperties`, `get_profiles`, `get_goals` и `get_segments`. Each of these functions returns a table of data (`data.frame`), with the relevant content.

Let's review these functions in details.

* `get_accounts` - getting the list of accounts to which the user has access. Return columns:
    - id - account ID;
    - name - account name;
    - created - Date of creating account;
    - updated -  date of last update of account;
* `get_webproperties` - getting a list of web propertys (Web Properties), to which the user has access. Return columns:
    - id - web property ID;
    - name - web property name;
    - websiteUrl - website URL;
    - level - level of the web property: standard or premium;;
    - profileCount - number of profiles (views) for the web property;
    - industryVertical - category / industry, which owns the web property;
    - created - Date of creating the web property;
    - updated - date of the last change of the web property;
* `get_profiles` - getting a list of web propertys (Web Properties) and views (Profiles) sites to which the user has access. Return columns:
    - id - profile ID;
    - accountId - account ID
    - webPropertyId - web property ID;
    - name - name of this view;
    - currency - currency;
    - timezone - timezone;
    - websiteUrl - website URL;
    - type - web property type: website or application;
    - created - date of creating submission;
    - updated - date of the last update of submission;
    - eCommerceTracking - e-commerce tracking;
    - siteSearchQueryParameters - query parameter to track search the site;
* `get_goals` - obtaining a list of goals to which the user has access. Return columns:
    - id - goal ID
    - accountId - account ID;
    - webPropertyId - resource ID;
    - profileId - profile ID;
    - name - goal name;
    - value - value of goal (currency);
    - active - activity status of the goal;
    - type - type of goal: event, the landing page, session duration, pages per session; 
    - created - date of goal creation;
    - updated - date of last change of goal;
* `get_segments` - obtaining a list of segments to which the user has access. Return columns:
    - id - segment ID;
    - segmentId - segment ID for use to query data;
    - name - segment name;
    - definition - segment definition:
    - type - type of segment: embedded or custom;
    - created - date of segment creation;
    - updated - date of the last change of segment;

For the functions such as `get_webproperties`, `get_profiles` and `get_goals`, can be specified the additional arguments such as ID аккаунта (`account.id`), resource (`webproperty.id`) or submission (`profile.id`), for which is required to obtain the information (view the help pages for the corresponding functions). Example of obtaining the information on all submissions is available to the user:

```R
get_profiles(token = token)
```

### Obtaining access to the metadata of API reports

For obtaining a list of all the metrics and dimensions the `RGA` package provides a dataset `ga`, which is available after loading the package. Access to the dataset is similar to access to any object in R - by the variable name.

```R
ga
```

The variable `ga` consists the the following columns:

* id - the parameter code name (metric or dimension) (used for queries);
* type - parameter type: metric (METRIC) or dimension (DIMENSION);
* dataType - data type: STRING, INTEGER, PERCENT, TIME, CURRENCY, FLOAT;
* group - group of parameters (ex. User, Session, Traffic Sources);
* status - status: actual (PUBLIC) or outdated (DEPRECATED);
* uiName - parameter name (not used for queries);
* description - parameter description;
* allowedInSegments - whether the parameter can be used in the segments;
* replacedBy - name of the replacement parameter, if the parameter is deprecated;
* calculation - formula of calculating the parameter value, if the parameter is calculated based on other parameters;
* minTemplateIndex - if the parameter contains a numeric index, the minimum parameter index;
* maxTemplateIndex - if the parameter contains a numeric index, the maximum parameter index;
* premiumMinTemplateIndex - if the parameter contains a numeric index, a minimum index for the parameter;
* premiumMaxTemplateIndex - if the parameter contains a numeric index, a maximum index for the parameter.

There are several examples of  usage the metadata Google Analytics API.

List of all outdated and replacing their parameters:

```R
subset(ga, status == "DEPRECATED", c(id, replacedBy))
```

List of all parameters from certain group:

```R
subset(ga, group == "Traffic Sources", c(id, type))
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