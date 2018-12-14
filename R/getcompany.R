
#' Get a list of companies, intelligently filtered by several criteria specified by user
#'
#' This function can make request THE MUSE API with "companies" endponit to get a list
#' of companies. The results it will return include the name of the company, a brief
#' description of the company, its location, related industries, its tag, the size,
#' official website, twitter, images, etc.
#'
#' @param page The page number to load (required).
#' @param decending  Whether to show descending results (default value: FALSE).
#' @param industry  The company industry to get, please refer to the vignette for
#'                  available industry categories.
#' @param size The company size to get, please refer to the vignette for available size choice.
#' @param location The office location to get.
#' @param apikey Pass your own API key can increase the rate limit from 500 to 3600 per hour.
#'
#' @return A named list with the following elements:
#'     \describe{
#'         \item{\strong{message}}{a list of messages including the number of results
#'             in specified pages, total number of results returned by the API}
#'         \item{\strong{response}}{a list of API-specific response values in JSON format,
#'             including the name of the company, a brief description of the company,
#'             its location, related industries, its tag, the size, official website, twitter,
#'             images, etc. At this time, no further coercion is performed, so you
#'             may have to use functions from the \code{jsonlite} package to extract
#'             the desired output. Or you can refer to the "cleancompany" function in this
#'             package to get a clean dataframe with some key information of list of companies.}
#'     }
#'
#' @keywords company, industry, size, location
#' @import httr
#' @import dplyr
#'
#' @export
#'
#' @examples
#' \dontrun{
#' getcompany(page = 1)
#' getcompany(page = 1, industry = "Tech")
#' getcompany(page = 1, size = "Large Size", location = "New York City, NY")}

getcompany <- function(
  page = NULL,
  decending = FALSE,
  industry = NULL,
  size = NULL,
  location = NULL,
  apikey = NULL) {
  if(missing(page)) stop("page is a required integer argument")
  if(!is.null(industry)) {
    industrylist <- c("Advertising and Agencies", "Arts and Music", "Consulting", "Education",
                      "Entertainment & Gaming", "Finance", "Government", "Insurance",
                      "Manufacturing", "Real Estate & Construction", "Social Media", "Telecom",
                      "Architecture", "Client Service", "Consumer", "Engineering",
                      "Fashion and Beauty", "Food", "Healthcare", "Law", "Media", "Social Good",
                      "Tech", "Travel and Hospitality")
    if(!(industry %in% industrylist)) stop("There is no such industry, please refer to the
                                           vignette for available industry categories.")
  }
  if(!is.null(size)) {
    sizelise <- c("Small Size", "Medium Size", "Large Size")
    if(!(size %in% sizelise)) stop("Please refer to the vignette for available size choice.")
  }
  if(!is.null(location)) {
    if(!grepl("\\b[A-Z]", location)) stop("The first letter of each word in 'location'
                                          should be uppercase.")
  }

  url2 <- "https://www.themuse.com/api/public/companies"
  query_param2 <- list(
    page = page,
    decending = decending,
    industry = industry,
    size = size,
    location = location,
    api_key = apikey)
  company <- GET(url2, query = query_param2)
  http_status(company)
  if(http_error(company)) warning("The request produced an error.")
  content(company)
  }
