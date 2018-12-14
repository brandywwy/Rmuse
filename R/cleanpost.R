
#' Get a clean dataframe of advice posts, including key information
#'
#' This function is designed to return a clean dataframe filled by parsed responses
#' from the specific MUSE API request for certain advice posts.
#'
#' @param page The page number to load (required).
#' @param decending Whether to show descending results(default value: FALSE).
#' @param tag Only show posts for a specific tag, please refer to the vignette to find proper available tags.
#' @param apikey Pass your own API key can increase the rate limit from 500 to 3600 per hour.
#'
#' @return A clean dataframe with following information:
#'         post name, publication date, type, excerpt, tags, author name, sponsor name and
#'         link.
#'
#' @keywords advice post, tag, dataframe
#' @import httr
#' @import jsonlite
#' @import dplyr
#'
#' @export
#'
#' @examples
#' \dontrun{
#' cleanpost(page = 1, tag = "Tools & Skills")}

cleanpost <- function(
  page = NULL,
  decending = NULL,
  tag = NULL,
  apikey = NULL) {
  if(missing(page)) stop("page is a required integer argument")
  if(!is.null(tag)) warning("Please refer to the vignette to find proper available tags.")

  url3 <- "https://www.themuse.com/api/public/posts"
  query_param3 <- list(
    page = page,
    decending = decending,
    tag = tag,
    api_key = apikey)
  post <- GET(url3, query = query_param3)
  http_status(post)
  if(http_error(post)) warning("The request produced an error.")
  postresult <- fromJSON(content(test3, as = "text"))
  postdf <- flatten(result3$results)
  finaldf3 <- postdf %>%
    select("post name" = name, "post id" = id, "publication data" = publication_date, type,
           excerpt, tags, "author name" = author.name, "sponsor name" = sponsor.name,
           "link" = refs.landing_page)
  for (i in 1:nrow(finaldf3)) {
    finaldf3$tags[i] <- if(is.null(unlist(finaldf3$tags[i]))) {
      NA
    } else {
      paste(unlist(finaldf3$tags[i]), collapse = ";")
    }
  }
  finaldf3$tags <- as.character(finaldf3$tags)

  warning("If no dataframe appears, it means there is no result for this search criteria.
          Otherwise, just ignore this message.")
  finaldf3
}
