
#' Get a list of coaches, intelligently filtered by several criteria specified by user
#'
#' This function can make request THE MUSE API with "coaches" endponit to get a list
#' of coaches. The results it will return include the amount of coaches that meet the criteria,
#' coache name, bio, certifications, specializations, rating, number of reviews, etc.
#'
#' @param page The page number to load (required).
#' @param decending Whether to show descending results(default value: FALSE).
#' @param offering  Only show coaches for a specific offering, please refer to the vignette
#'                  to find proper available offering options.
#' @param level Only show coaches for a specific level, please refer to the vignette for
#'              available level categories.
#' @param specialization Only show coaches for a specific specialization, please refer to the
#'                       vignette to find proper available specializaiton options.
#' @param apikey Pass your own API key can increase the rate limit from 500 to 3600 per hour.
#'
#' @return A named list with the following elements:
#'     \describe{
#'         \item{\strong{message}}{a list of messages including the number of results
#'             in specified pages, total number of results returned by the API}
#'         \item{\strong{response}}{a list of API-specific response values in JSON format,
#'             including coache name, bio, certifications, specializations, rating,
#'             number of reviews, etc. At this time, no further coercion is performed, so you
#'             may have to use functions from the \code{XML} package to extract
#'             the desired output. Or you can refer to the "cleancoach" function in this
#'             package to get a clean dataframe with some key information of list of coaches.}
#'     }
#'
#' @keywords coach, level, offering, specialization
#' @import httr
#' @import dplyr
#'
#' @export
#'
#' @examples
#' \dontrun{
#' getcoach(page = 1, offering = "30-Minute Career Q&A")
#' getcoach(page = 2, level = "Master Coach", specialization = "College/New Grads")}

getcoach <- function(
  page = NULL,
  decending = NULL,
  offering = NULL,
  level = NULL,
  specialization = NULL,
  apikey = NULL) {
  if(missing(page)) stop("page is a required integer argument")
  if(!is.null(offering)) warning("Please refer to the vignette to find proper available
                                 offering options.")
  if(!is.null(level)) {
    levellist <- c("Mentor", "Coach", "Master Coach")
    if(!(level %in% levellist)) stop("There is no such levek, please refer to the
                                           vignette for available level categories.")
  }
  if(!is.null(specialization)) warning("Please refer to the vignette to find proper available
                                 specializaiton options.")

  url4 <- "https://www.themuse.com/api/public/coaches"
  query_param4 <- list(
    page = page,
    decending = decending,
    offering = offering,
    level = level,
    specialization = specialization,
    api_key = apikey)
  coach <- GET(url4, query = query_param4)
  http_status(coach)
  if(http_error(coach)) warning("The request produced an error.")
  content(coach)
}
