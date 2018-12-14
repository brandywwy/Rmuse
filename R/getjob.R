
#' Get a list of jobs, intelligently filtered by several criteria specified by user
#'
#' This function can make request THE MUSE API with "jobs" endponit to get a list
#' of jobs. The results it will return include the amount of jobs that meet the criteria,
#' the job description, the job title, job id, location, related company, etc.
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
#' @return A named list with the following elements:
#'     \describe{
#'         \item{\strong{message}}{a list of messages including the number of results
#'             in specified pages, total number of results returned by the API}
#'         \item{\strong{response}}{a list of API-specific response values in JSON format,
#'             including the job description, the job title, job id, location,
#'             related company, etc. At this time, no further coercion is performed, so you
#'             may have to use functions from the \code{jsonlite} package to extract
#'             the desired output. Or you can refer to the "cleanjob" function in this
#'             package to get a clean dataframe with some key information of list of jobs.}
#'     }
#'
#' @keywords job, company, level, location
#' @import httr
#' @import dplyr
#' @export
#'
#' @examples
#' \dontrun{
#' getjob(page = 1)
#' getjob(page = 1, level = "Entry Level", category = "Data Science")
#' getjob(page = 2, company = "Lyft", location = "Chicago, IL")}

getjob <- function(
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
  content(job)
}
