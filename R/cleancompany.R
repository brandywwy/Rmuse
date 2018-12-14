
#' Get a clean dataframe of companies, including key information
#'
#' This function is designed to return a clean dataframe filled by parsed responses
#' from the specific MUSE API request for certain companies.
#'
#' @param page The page number to load (required).
#' @param decending  Whether to show descending results (default value: FALSE).
#' @param industry  The company industry to get, please refer to the vignette for
#'                  available industry categories.
#' @param size The company size to get, please refer to the vignette for available size choice.
#' @param location The office location to get.
#' @param apikey Pass your own API key can increase the rate limit from 500 to 3600 per hour.
#'
#' @return A clean dataframe with following information:
#'         company name, locations, industries, size, description, tags, twitter, link and logo.
#'
#' @keywords company, industry, size, location, dataframe
#' @import httr
#' @import jsonlite
#' @import dplyr
#'
#' @export
#'
#' @examples
#' \dontrun{
#' cleancompany(page = 1)
#' cleancompany(page = 1, industry = "Tech")
#' cleancompany(page = 1, size = "Large Size", location = "New York City, NY")}

cleancompany <- function(
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
  companyresult <- fromJSON(content(company, as = "text"))
  companydf <- flatten(companyresult$results)
  finaldf2 <- companydf %>%
    select("company name" = name, "company ID" = id, locations, industries, "size" = size.name,
           description, tags, twitter, "comoany page" = refs.landing_page, "job page" = refs.jobs_page,
           "logo link" = refs.logo_image)
  for (i in 1:nrow(finaldf2)) {
    finaldf2$locations[i] <- if(is.null(unlist(finaldf2$locations[i]))) {
      NA} else {
        paste(unlist(finaldf2$locations[i]), collapse = ";")
      }
    finaldf2$industries[i] <- if(is.null(unlist(finaldf2$industries[i]))) {
      NA} else {
        paste(unlist(finaldf2$industries[i]), collapse = ";")
      }
    finaldf2$tags[i] <- if(is.null(unlist(finaldf2$tags[i]))) {
      NA} else {
        paste(unlist(finaldf2$tags[i])["name"], collapse = ";")
      }
  }
  finaldf2$locations <- as.character(finaldf2$locations)

  finaldf2$industries <- as.character(finaldf2$industries)

  finaldf2$tags <- as.character(finaldf2$tags)

  warning("If no dataframe appears, it means there is no result for this search criteria.
          Otherwise, just ignore this message.")
  finaldf2
  }
