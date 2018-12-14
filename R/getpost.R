
#' Get a list of posts, intelligently filtered by tag specified by user
#'
#' This function can make request THE MUSE API with "posts" endponit to get a list
#' of advice posts. The results it will return include the amount of posts that meet the criteria,
#' the name of the post, the excerpt, its tags, its author, the reference link, etc.
#'
#' @param page The page number to load (required).
#' @param decending Whether to show descending results(default value: FALSE).
#' @param tag Only show posts for a specific tag, please refer to the vignette to find proper available tags.
#' @param apikey Pass your own API key can increase the rate limit from 500 to 3600 per hour.
#'
#' @return A named list with the following elements:
#'     \describe{
#'         \item{\strong{message}}{a list of messages including the number of results
#'             in specified pages, total number of results returned by the API}
#'         \item{\strong{response}}{a list of API-specific response values in JSON format,
#'             including the name of the post, the excerpt, its tags,
#'             its author, the reference link, etc. At this time, no further coercion
#'             is performed, so you may have to use functions from the \code{jsonlite} package
#'             to extract the desired output. Or you can refer to the "cleanpost" function
#'             in this package to get a clean dataframe with some key information of list of posts.}
#'     }
#'
#' @keywords advice post, tag
#' @import httr
#' @import dplyr
#'
#' @export
#'
#' @examples
#' \dontrun{
#' getpost(page = 1, tag = "Tools & Skills")}

getpost <- function(
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
  content(post)
}
