# RGA

This package is designed to work with the **API Google Analytics** in **R**.

Key features:

* Support for OAuth 2.0 authentication;
* Access to the API configuration (including accounts information, profiles, purposes, segments);
* Access to the API basic reports and the reports of multichannel sequences;
* Support of the batch processing of the requests (allows to overcome the restriction on the number of rows returned for a single request).
* Access to the metadata of the API reports.

## Installation

Notice: Currently the Package RGA is in development and is not available via a CRAN network
Prerequisites:

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
    * Click on the red button labeled **Create Project** at the top left of the page;
    * In the pop-up window, enter the name of the project in the **PROJECT NAME** field;
    * Click on **Create** to confirm the creation of the project.
2. Activation of the access to the API Google Analytics:
    * Select the project from the project list on page ttps://console.developers.google.com/project;
    * Select **APIs & auth** in the left sidebar;
    * In the **APIs** tab, activate **Analytics API**, by clicking on **OFF** button.
3. Creating a new application:
    * In the left sidebar, select **APIs & auth** and **Credentials** subparagraph;
    * On the left side of the page click on the button labeled **Create new Client ID**;
    * In the pop-up window, select **Installed application** from the APPLICATION TYPE list and **Other** from INSTALLED APPLICATION TYPE list.
    * Confirm the creation of the application by clicking on the **Create Client ID** button.
4. Obtaining Client ID and Client secret:
    * Select the project from the project list on page https://console.developers.google.com/project;
    * In the left sidebar, select **APIs & auth** and **Credentials** subparagraph;
    * In the table called **Client ID for native application**, copy the values of the **Client ID** and **Client secret** fields.