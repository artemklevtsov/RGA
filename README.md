# RGA

This package is designed to work with the **API Google Analytics** in **R**.

Key features:

* Support for OAuth 2.0 authentication;
* Access to the API management (including accounts information, profiles, goals, segments);
* Access to the API core reports and the reports of multi-channel funnels;
* Support of the batch processing of the requests (allows to overcome the restriction on the number of rows returned for a single request).
* Access to the metadata of the API reports.

## Installation

Notice: Currently the package `RGA` is in development and is not available via a CRAN network

### Requirements

* R version should be at least 2.15.0;
* Packages `RCurl`, `httr` and `jsonlite`;
* `devtools` package.

### Installing the `devtools` package

To install the latest version `devtools` package, use the following command:

```R
install.packages("devtools", dependencies = TRUE)
```

### Installing the `RGA` package 

`RGA` can be installed from the git-repository:

```R
library(devtools)
install_bitbucket(repo = "rga", username = "unikum")
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