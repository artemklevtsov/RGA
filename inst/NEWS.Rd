\name{NEWS}
\title{News for Package \pkg{RGA}}
\encoding{UTF-8}

\section{Changes in RGA version 0.3.2 (2015-12-27)}{
  \itemize{
    \item Updated data
    \item Fixed \code{row.names} attribute when used \code{fetch.by}
    \item \code{new.auth} param renamed to \code{reauth} in the \code{authorize()} function
    \item Added \code{rga.profile.id} option to set \code{profile.id} param in the Reporting API functions
  }
}

\section{Changes in RGA version 0.3.1 (2015-11-30)}{
  \itemize{
    \item Added startup message with a warning about using predefined credentials
    \item Updated instructions for obtaining an OAuth credentials
    \item To handle dates used \CRANpkg{lubridate} package
    \item To merge paginated data used \CRANpkg{plyr} package
    \item Improved pagination requests. Now allowed any positive integer in the \code{max.results}
    \item \code{list_custom_sources()} renamed to \code{list_custom_data_sources()}
    \item \code{dimension.id} param renamed to \code{custom.dimension.id} in the \code{get_custom_dimension()}
    \item \code{metric.id} param renamed to \code{custom.metric.id} in the \code{get_custom_metric()}
    \item Imprvoed handling an error messages
    \item If \code{profile.id} not defined, First found profile used on this account
    \item Added \code{rga.retry.attempts} (default value is \code{5L}) option to control number of the request retry attempts
    \item Added \code{rga.pagination} (default values is \code{TRUE}) option to switch the batch processing mode
    \item Some inner code improvements
  }
}

\section{Changes in RGA version 0.3 (2015-10-23)}{
  \itemize{
    \item Updated data
    \item Removed \sQuote{Common Queries} vegnette. See references in the \code{get_ga()} help page
    \item Added (returned) \code{shiny_dimsmets()} to explore dimensions and metrics for the Core Reporting API
    \item Removed unused the \code{rga.token} package option
    \item Removed deprecated \code{get_rt()} function. Use \code{get_realtime()} instead
    \item The \code{sampling.level} argument value now must be in the upper case
    \item Added text progress bar when batch processing mode enabled
    \item Added \code{fetch.by} option for the \code{get_ga()} and \code{get_mcf()} functions to split the queries by date ranges (day, week, month, quarter, year)
    \item Added the \CRANpkg{shiny} an example application authorization
    \item Added the \CRANpkg{shiny} an example fetching realtime reporting data
    \item If User Rate Limit Exceeded or Quota Exceeded error occurs, the request is retried using exponential backoff
    \item Some inner code improvements
  }
}

\section{Changes in RGA version 0.2.4 (2015-08-31)}{
  \itemize{
    \item Updated data
    \item Added query and profile info to the reporting api data functions: \code{get_ga()}, \code{get_mcf()}, \code{get_rt()} (use \code{attributes()} to see it)
    \item Added \code{username} param to the \code{authorize()} function to define an user account for the authorization
    \item \code{get_rt()} renamed to \code{get_realtime()}
    \item \code{list_metadata()} renamed to \code{list_dimsmets()}
    \item Removed \code{dimsmets()} function and \CRANpkg{shiny} dependency (use \code{View(list_dimsmets())} instead)
    \item Updated minimal \CRANpkg{httr} version to 1.0.0
  }
}

\section{Changes in RGA version 0.2.3 (2015-07-26)}{
  \itemize{
    \item Updated data
    \item Removed deprecated function \code{get_firstadate()}. Use \code{firstdate()} instead
    \item Added \code{new.auth} argument in the \code{authorise()} function for the reauthorization
    \item When receiving the authorization error from the server (error 401), request authorization for the current session (without cacheing)
    \item Fixed \code{list_unsampled_reports()} field typo
    \item Some fixes in the vignettes
    \item Added \dQuote{Common Queries} vignette
  }
}

\section{Changes in RGA version 0.2.2 (2015-06-13)}{
  \itemize{
    \item Updated data
    \item Added \code{accept_json()} to the API requests
    \item Added CRAN version badge to the README
    \item Some fixes in the vignettes
    \item Fixed dates in the NEWS
    \item \CRANpkg{RCurl} dependency replaced by \CRANpkg{curl} (related with \CRANpkg{httr} 1.0.0 update)
    \item Added functions for the Management API: \code{get_custom_dimension()}, \code{list_custom_dimensions()}, \code{get_custom_metric()}, \code{list_custom_metrics()}
  }
}

\section{Changes in RGA version 0.2.1 (2015-03-17)}{
  \itemize{
    \item Fixed column names in the \dQuote{Metadata API} vignette
    \item \code{dimsmets()} now try to get data with \code{list_metadata()}. If \code{list_metadata()} causes a error used data from the package
    \item Fixed Title in the DESCRIPTION file
  }
}

\section{Changes in RGA version 0.2 (2015-02-02)}{
  \itemize{
    \item Updated data
    \item Fixed package descrition in the DESCRIPTION file
    \item Added more functions for the Management API: \code{get_experiment()}, \code{get_filter()}, \code{get_unsampled_report()}, \code{list_custom_sources()}, \code{list_experiments()}, \code{list_filters()}, \code{list_unsampled_reports()}
    \item Removed deprecated functions: \code{get_accounts()}, \code{get_webproperties()}, \code{get_profiles()}, \code{get_goals()}, \code{get_segments()}
    \item Names of the returned objects now converted to a period-separated style
    \item Improved errors handling
    \item Added information about a percent of sessions when sampled data returned
    \item Added \code{rga.cache} package option to specify default cache path
    \item Added \code{rga.token} package option to specify the variable name which assign in the \code{RGA:::TokenEnv} environment when use \code{authorise()}
    \item Removed \code{rga.verbose} option and \code{verbose} arg. Use \code{httr::with_verbose()} instead
    \item Added \code{list_metadata()} function to obtain actual information from the Metadata API
    \item \code{dims_mets()} renamed to \code{dimsmets()}. \code{dims_mets()} now is deprecated
    \item \code{get_firstdate()} renamed to \code{firstdate()}. \code{get_firstdate()} now is deprecated
    \item Dates in the returned objects now converted to the \code{POSIXct} class
    \item Fixed incorrect handling \dQuote{ga:dateHour} dimension
    \item Use timezone specified in the Profile settings for handling dates
    \item Added predefined \code{client.id} and \code{client.secret} for the \code{authorise()} function
    \item Fixed code related with \CRANpkg{shiny} update (version 0.11)
    \item README splitted to the separate vignettes
    \item Updated minimal versions of the required dependencies: \R >= 3.0.0, \CRANpkg{httr} >= 0.6, \CRANpkg{shiny} >= 0.11
  }
}

\section{Changes in RGA version 0.1.4 (2014-12-19)}{
  \itemize{
    \item Updated data
    \item All query values now converted to UTF-8 (to solve issues with Windows encoding)
    \item Returned URL encode for the queries and \CRANpkg{RCurl} as explicit dependency
    \item Fixed \code{get_mcf} example
    \item Added notes about multiple tokens usage
    \item Removed \code{set_query} and related S3-methods from exported namespace
    \item Parsed environment variables \env{RGA_CONSUMER_ID} and \env{RGA_CONSUMER_SECRET} renamed to \env{RGA_CLIENT_ID} and \env{RGA_CLIENT_SECRET}
    \item \code{get_accounts()} renamed to \code{list_accounts()}
    \item \code{get_webproperties()} renamed to \code{list_webproperties()}
    \item \code{get_profiles()} renamed to \code{list_rpofiles()}
    \item \code{get_goals()} renamed to \code{list_goals()}
    \item \code{get_segments()} renamed to \code{list_segments()}
    \item \code{get_accounts()}, \code{get_webproperties()}, \code{get_profiles()}, \code{get_goals()}, \code{get_segments()} marked as deprecated
    \item Added \code{get_webproperty()}, \code{get_profile()} and \code{get_goal()} functions to get more detailed informtion about specific Profile ID
    \item Added default package options when loading
    \item Added \code{sampling.level} option to the \code{gat_ga()} and \code{get_mcf()} functions to control sampling level
  }
}

\section{Changes in RGA version 0.1.3 (2014-10-20)}{
  \itemize{
    \item Updated data
    \item Added CSV version of the data to track changes
    \item Fixed error when used query and path simultaneously
    \item Added pagination for the Management API requests
    \item Fixed limits per request for the Reporting and Management APIs
    \item Fixed pagination issues
    \item \code{show_dimsmets()} renamed to \code{dims_mets()}
    \item Added more messages when \code{verbose = TRUE}
    \item Removed URL encode for the queries and \CRANpkg{RCurl} package dependency (related with Windows encoding)
  }
}

\section{Changes in RGA version 0.1.2 (2014-09-01)}{
  \itemize{
    \item Some internal code improvements and optimisations
  }
}

\section{Changes in RGA version 0.1.1 (2014-08-20)}{
  \itemize{
    \item Added more extend Descrition in the DESCRIPTION file
  }
}

\section{Changes in RGA version 0.1 (2014-08-19)}{
  \itemize{
    \item Initial release
  }
}

