# RGA

[![Travis-CI Build Status](https://travis-ci.org/artemklevtsov/RGA.svg?branch=master)](https://travis-ci.org/artemklevtsov/RGA) [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/RGA)](http://cran.r-project.org/package=RGA)

This package is designed to work with the [API Google Analytics](https://developers.google.com/analytics) in [R](http://www.r-project.org/).

Key features:

* [OAuth 2.0](https://developers.google.com/accounts/docs/OAuth2) authorization;
* Auto refresh an expired OAuth access token;
* Access to all the accounts which the user has access to;
* API responses is converted directly into R objects;
* Access to the following [Google Analytics APIs](https://developers.google.com/analytics/devguides/platform/):
    - [Management API](https://developers.google.com/analytics/devguides/config/mgmt/v3): access to configuration data for accounts, web properties, views (profiles), goals and segments;
    - [Core Reporting API](https://developers.google.com/analytics/devguides/reporting/core/v3): query for dimensions and metrics to produce customized reports;
    - [Multi-Channel Funnels Reporting API](https://developers.google.com/analytics/devguides/reporting/mcf/v3): query the traffic source paths that lead to a user's goal conversion;
    - [Real Time Reporting API](https://developers.google.com/analytics/devguides/reporting/realtime/v3): report on activity occurring on your property at the moment;
    - [Metadata API](https://developers.google.com/analytics/devguides/reporting/metadata/v3): access the list of API dimensions and metrics and their attributes;
* Auto-pagination to return more than 10,000 rows of the results by combining multiple data requests.

## Installation

To install the latest release version from CRAN with:

```r
install.packages("RGA")
```

To install the development version the `install_github()` function from `devtools` package can be used:

```r
devtools::install_github("artemklevtsov/RGA")
```

Another method to install the package `RGA` (using the command line):

```bash
git clone https://github.com/artemklevtsov/RGA.git
R CMD build RGA
R CMD INSTALL RGA_*.tar.gz
```

## Usage

Once you have the package loaded, there are 3 steps you need to use to get data from Google Analytics:

1. Authorize this package to access your Google Analytics data with the `authorize()` function;
1. Determine the profile ID which you want to get access to with the `list_profiles()` function;
1. Get the anaytics data from the API with one of these functions:
    - `get_ga()` for the Core Reporting API
    - `get_mcf()` for the Multi-Channel Funnels Reporting API
    - `get_realtime()` for the Real Time Reporting API

For details about this steps please type into R:

```r
library(help = "RGA")
browseVignettes(package = "RGA")
```

## Bug reports

First check the changes in the latest version of the package. Type type into R:

```r
news(package = "RGA", Version == packageVersion("RGA"))
```

Before posting a bug please try execute your code with the `httr::with_verbose()` wrapper. It will be useful if you attach verbose output to the bug report.

```r
httr::with_verbose(list_profiles())
httr::with_verbose(get_ga("XXXXXXXX"))
```

Post the `traceback()` output also may be helpful.

To report a bug please type into R:

```r
utils::bug.report(package = "RGA")
```
