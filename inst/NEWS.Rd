\newcommand{\cpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}
\newcommand{\issue}{\href{https://bitbucket.org/unikum/rga/issue/#1}{##1}}
\name{NEWS}
\title{News for Package \pkg{RGA}}
\encoding{UTF-8}

\section{Changes in version 0.2.2 (2015-06-13)}{
  \itemize{
    \item Update data
    \item Add \code{accept_json()} to the API requests
    \item Add CRAN version badge to the README
    \item Fix headings in the Authentification vignette
    \item Fix dates in the NEWS
    \item Replace \cpkg{RCurl} dependency to \cpkg{curl}
    \item Add \code{get_custom_dimension}, \code{list_custom_dimensions}, \code{get_custom_metric}, \code{list_custom_metrics} functions
  }
}

\section{Changes in version 0.2.1 (2015-03-17)}{
  \itemize{
    \item Fix column names in the Metadata API vignette
    \item \code{dimsmets()} now try to get data with \code{list_metadata()}. If \code{list_metadata()} caeses a error used data from the package
    \item Fix Title in the DESCRIPTION file as was recommended by Brian Ripley
  }
}

\section{Changes in version 0.2 (2015-02-02)}{
  \itemize{
    \item Update data
    \item Fix Descrition in the DESCRIPTION file as was recommended by Brian Ripley
    \item Add more functions for the Management API: \code{get_experiment()}, \code{get_filter()}, \code{get_unsampled_report()}, \code{list_custom_sources()}, \code{list_experiments()}, \code{list_filters()}, \code{list_unsampled_reports()}
    \item Remove deprecated functions: \code{get_accounts()}, \code{get_webproperties()}, \code{get_profiles()}, \code{get_goals()}, \code{get_segments()}
    \item Convert output names to period-separated style
    \item Improve errors handling
    \item Add information about a percent of sessions when sampled data returned
    \item Add \code{rga.cache} package option to specify default cache path
    \item Add \code{rga.token} package option to specify the variable name which assign in the \code{RGA:::TokenEnv} environment when use \code{authorise()}
    \item Remove \code{rga.verbose} option and \code{verbose} arg. Use \code{httr::with_verbose()} instead
    \item Add \code{list_metadata()} function to obtain actual information from the Metadata API
    \item Rename \code{dims_mets()} to \code{dimsmets()}. \code{dims_mets()} now is deprecated
    \item Rename \code{get_firstdate()} to \code{firstdate()}. \code{get_firstdate()} now is deprecated
    \item Dates now converted in the \code{POSIXct} class
    \item Fix incorrect handling ga:dateHour dimension (\issue{15})
    \item Use timezone specified in the Profile settings for handling dates
    \item Add predefined \code{client.id} and \code{client.secret} for the \code{authorise()} function
    \item Update code related with shiny update (version 0.11)
    \item Split README to the separate vignettes
    \item Update minimal versions of the required dependencies: \R >= 3.0.0, \cpkg{httr} >= 0.6, \cpkg{shiny} >= 0.11
  }
}

\section{Changes in version 0.1.4 (2014-12-19)}{
  \itemize{
    \item Update data
    \item Convert all query values to UTF-8 (solve issues with Windows encoding)
    \item Return URL encode for the queries and \cpkg{RCurl} as explicit dependency
    \item Fix get_mcf example (\issue{9})
    \item Add notes about multiple tokens usage (\issue{7})
    \item Remove set_query and related S3-methods from exported namespace
    \item Parsed environment variables \env{RGA_CONSUMER_ID} and \env{RGA_CONSUMER_SECRET} renamed to \env{RGA_CLIENT_ID} and \env{RGA_CLIENT_SECRET}
    \item \code{get_accounts()}, \code{get_webproperties()}, \code{get_profiles()}, \code{get_goals()}, \code{get_segments()} renamed to \code{list_accounts()}, \code{list_webproperties()}, \code{list_rpofiles()}, \code{list_goals()}, \code{list_segments()}
    \item \code{get_accounts()}, \code{get_webproperties()}, \code{get_profiles()}, \code{get_goals()}, \code{get_segments()} mark as deprecated
    \item Add \code{get_webproperty()}, \code{get_profile()} and \code{get_goal()} functions to get more detailed informtion about specific ID
    \item Set default package optiions when loading
    \item Add \code{sampling.level} option to the \code{gat_ga()} and \code{get_mcf()} functions to control sampling level
  }
}

\section{Changes in version 0.1.3 (2014-10-20)}{
  \itemize{
    \item Update data
    \item Add CSV version of the data to track changes
    \item Fix error when used query and path simultaneously (inner) (\issue{6})
    \item Add pagination for the Management API requests
    \item Fix quotas for the Reporting and Management APIs
    \item Fix pagination issues
    \item \code{show_dimsmets()} was renamed to \code{dims_mets()}
    \item Add more messages when \code{verbose = TRUE}
    \item Remove URL encode for the queries and \cpkg{RCurl} package dependency (related with Windows encoding)
  }
}

\section{Changes in version 0.1.2 (2014-09-01)}{
  \itemize{
    \item Some internal code improvements
  }
}

\section{Changes in version 0.1.1 (2014-08-20)}{
  \itemize{
    \item Add more extend Descrition in the DESCRIPTION file as was requested Brian Ripley
  }
}

\section{Changes in version 0.1 (2014-08-19)}{
  \itemize{
    \item First release
  }
}

