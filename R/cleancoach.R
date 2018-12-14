
#' Get a clean dataframe of coaches, including key information
#'
#' This function is designed to return a clean dataframe filled by parsed responses
#' from the specific MUSE API request for certain coaches.
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
#' @return A clean dataframe with following information:
#'         coach name, rating, reviews, bio, specializations, level, link and image.
#'
#' @keywords coach, offering, level, specialization, dataframe
#' @import httr
#' @import jsonlite
#' @import dplyr
#'
#' @export
#'
#' @examples
#' \dontrun{
#' cleancoach(page = 1, offering = "30-Minute Career Q&A")
#' cleancoach(page = 2, level = "Master Coach", specialization = "College/New Grads")}

cleancoach <- function(
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
  coachresult <- fromJSON(content(coach, as = "text"))
  coachdf <- flatten(result4$results)
  finaldf4 <- coachdf %>%
    select("coach name" = name, "coach ID" = id, rating, reviews, "brief introduction" = bio,
           specializations, "level" = level.name, "coach link" = refs.link, "coach image" = refs.image)
  for (i in 1:nrow(finaldf4)) {
    finaldf4$specializations[i] <- if(is.null(unlist(finaldf4$specializations[i]))) {
      NA
    } else {
      paste(unlist(finaldf4$specializations[i]), collapse = ";")
    }
  }
  finaldf4$specializations <- as.character(finaldf4$specializations)

  warning("If no dataframe appears, it means there is no result for this search criteria.
          Otherwise, just ignore this message.")
  finaldf4
  }
