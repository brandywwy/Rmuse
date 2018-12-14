
#' Get a clean dataframe of jobs, including key information
#'
#' This function is designed to return a clean dataframe filled by parsed responses
#' from the specific MUSE API request for certain jobs.
#'
#' @param page The page number to load (required).
#' @param decending Whether to show descending results(default value: FALSE).
#' @param company Only get jobs for these companies.
#' @param category The job category to get, please refer to the vignette for available categories.
#' @param level The experience level required for the job, please refer to the vignette
#'              for available levels.
#' @param location The job location to get (you can include flexible/remote jobs from here).
#' @param apikey Pass your own API key can increase the rate limit from 500 to 3600 per hour.
#'
#' @return A clean dataframe with following information:
#'         job title, publication date, locations, categories, levels, tags, company name,
#'         link and job description.
#' @keywords job, companny, category, level, dataframe
#' @import httr
#' @import jsonlite
#' @import dplyr
#'
#' @export
#'
#' @examples
#' \dontrun{
#' cleanjob(page = 1)
#' cleanjob(page = 1, level = "Entry Level", category = "Data Science")
#' cleanjob(page = 2, company = "Lyft", location = "Chicago, IL")}

cleanjob <- function(
  page =  NULL,
  decending = FALSE,
  company = NULL,
  category = NULL,
  level = NULL,
  location = NULL,
  apikey = NULL) {
  if(missing(page)) stop("'page' is a required integer argument")
  if(!is.null(company)) {
    if(!grepl("\\b[A-Z]", company)) stop("The first letter of each word in 'company'
                                         should be uppercase.")
  }
  if(!is.null(category)) {
    categorylist <- c("Account Management", "Creative & Design", "Data Science", "Education",
                      "Finance", "Healthcare & Medicine", "Legal", "Operations", "Retail",
                      "Social Media & Community", "Business & Strategy", "Customer Service",
                      "Editortial", "Engineering", "Fundraising & Development", "HR & Recruiting",
                      "Marketing & PR", "Project & Product Management", "Sales")
    if(!(category %in% categorylist)) stop("There is no such category, please refer to the
                                           vignette for available categories.")
  }
  if(!is.null(level)) {
    levellist <- c("Internship", "Entry Level", "Mid Level", "Senior Level")
    if(!(level %in% levellist)) stop("There is no such level, please refer to the vignette
                                     for available levels.")
  }
  if(!is.null(location)) {
    if(!grepl("\\b[A-Z]", location)) stop("The first letter of each word in 'location'
                                          should be uppercase.")
  }

  url1 <- "https://www.themuse.com/api/public/jobs"
  query_param1 <- list(
    page = page,
    decending = decending,
    company = company,
    category = category,
    level = level,
    location = location,
    api_key = apikey)
  job <- GET(url1, query = query_param1)
  http_status(job)
  if(http_error(job)) warning("The request produced an error.")
  jobresult <- fromJSON(content(job, as = "text"))
  jobdf <- flatten(jobresult$results)
  finaldf1 <- jobdf %>%
    select("job title" = name, "publication date" = publication_date, id, locations, categories,
           levels, tags, "company ID" = company.id, "company name" = company.name,
           "link" = refs.landing_page, "job description" = contents)
  for (i in 1:nrow(finaldf1)) {
    finaldf1$locations[i] <- if(is.null(unlist(finaldf1$locations[i]))) {
      NA
    } else {
      paste(unlist(finaldf1$locations[i]), collapse = ";")
    }
    finaldf1$categories[i] <- if(is.null(unlist(finaldf1$categories[i]))) {
      NA} else {
        paste(unlist(finaldf1$categories[i]), collapse = ";")
      }
    finaldf1$levels[i] <- if(is.null(unlist(finaldf1$levels[i]))) {
      NA} else {
        unlist(finaldf1$levels[i])["name"]
      }
    finaldf1$tags[i] <- if(is.null(unlist(finaldf1$tags[i]))) {
      NA} else {
        paste(unlist(finaldf1$tags[i]), collapse = ";")
      }
  }
  finaldf1$locations <- as.character(finaldf1$locations)

  finaldf1$categories <- as.character(finaldf1$categories)

  finaldf1$levels <- as.character(finaldf1$levels)

  finaldf1$tags <- as.character(finaldf1$tags)

  warning("If no dataframe appears, it means there is no result for this search criteria.
          Otherwise, just ignore this message.")
  finaldf1
  }
