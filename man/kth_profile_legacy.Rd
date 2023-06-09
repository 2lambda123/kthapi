% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/profile.R
\name{kth_profile_legacy}
\alias{kth_profile_legacy}
\title{Retrieve data for KTH Profiles}
\usage{
kth_profile_legacy(userid = NULL, config = NULL)
}
\arguments{
\item{userid}{a string with the account name or KTH user id}

\item{config}{a configuration setting for the KTH APIs including base URL etc, by default from config()}
}
\value{
results records returned from the search
}
\description{
This API does supports the existing profile api, version 1.1 and has no access key requirements.
}
\details{
See details at \url{https://api.kth.se/api/profile/swagger/?url=/api/profile/swagger.json#/v1.1/getPublicProfile_v11}
}
\examples{
\dontrun{
kth_profile_legacy("agnel")
kth_profile_legacy("tjep")
tryCatch(kth_profile(username = "hoyce"), error = function(e) e, warning("Does not exist?"))
}
}
