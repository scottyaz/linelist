#' Accessor functfons
#'
#' This set of fucntions defines helper functions for accessing pre-defined
#' epivars in your linelist object.
#'
#' @param x a linelist object
#' 
#' @param ... *epivars* to be used; can be provided as characters, integers,
#'   or logical; integers and logicals are to be matched against the vector of
#'   epi variables returned by `list_epivars(x, simple = TRUE)`. If nothing is
#'   provided, all *epivars* are returned.
#'
#' @param simplify if `TRUE` (default) and a single epivar is specified, it will
#'   be converted to a `vector`. Otherwise, a data frame is returned.
#'
#' @return a vector if the epivar can be represented by a single column, a data
#'   frame otherwise (e.g. a location column).
#'
#' @note For the `geo()` accessor, which necessarily contains two columns for
#'   longitude and latitude data, when `simplify = TRUE`, a matrix will be
#'   returned.
#'
#' @export
#' @rdname accessors
#' @examples
#'
#' ## make toy data
#' toy_data <- messy_data()
#' cleaned_data <- clean_data(toy_data)
#' ll <- as_linelist(cleaned_data, 
#'                   id = "id", 
#'                   date_onset = "date_of_onset",
#'                   gender = "gender",
#'                   geo_lon = "lon",
#'                   geo_lat = "lat"
#'                  ) 
#'
#' ## general purpose accessor
#' list_epivars(ll, simple = TRUE)
#' get_epivars(ll) # all epi variable
#' get_epivars(ll, "id", "date_onset", "gender") # named epi variables
#' date_onset(ll)
#' id(ll)
#' gender(ll)
#' geo(ll) # a matrix with two columns
#' get_epivars(ll, "geo_lon", "geo_lat", simplify = FALSE) # a data frame with two columns
#'
#' # epivars that haven't been defined for the data set will return an error
#' try(date_report(ll))
#' @importFrom stats setNames
#' @rdname accessors
#' @export

get_epivars <- function(x, ..., simplify = TRUE) {
  if (is.null(attr(x, "epivars"))) {
    stop("This object has no 'epivars' attribute")
  }
  # Collect data epivars and user-supplied epivars -----------------
  vars    <- list(...)
  epivars <- attr(x, "epivars")

  # Check for empty set --------------------------------------------
  # No variables were defined, so return the subset of the data frame with the
  # defined epivars
  if (length(vars) == 0) {
    return(as.data.frame(x[unlist(attr(x, "epivars"), use.names = FALSE)]))
  }
  
  # Check for a vector----------------------------------------------
  # A vector of variables was passed: turn it into a list
  if (length(vars) == 1 && is.character(vars[[1]])) {
    vars <- as.list(vars[[1]])
  }

  # Make sure the list is not nested -------------------------------
  if (any(lengths(vars) > 1)) {
    stop("All variables must be of length 1.")
  }

  # Make sure that all the inputs are characters -------------------
  are_characters <- vapply(vars, is.character, logical(1))
  if (!all(are_characters)) {
    stop("all variables must be characters.")
  }

  # validate the list -----------------------------------------------
  vars       <- valid_dots(setNames(vars, unlist(vars, use.names = FALSE)))
  valid_vars <- names(vars) %in% names(epivars)
  if (!all(valid_vars)) {
    invalids <- paste(names(vars)[!valid_vars], collapse = ", ")
    stop(sprintf("The following epivars were not found in the data:\n%s", 
                 invalids))
  }

  # Keep only the vars that pass the above tests --------------------
  to_keep <- unlist(epivars[names(vars)], use.names = FALSE)
  # Note: subsetting first and then converting is needed to prevent 
  # as.data.frame from changing the column names 
  out <- as.data.frame(x[to_keep])
  if (simplify && ncol(out) == 1L) {
    out <- out[, 1, drop = TRUE]
  }
  out
}







#' @rdname accessors
#' @export
id <- function(x) {
  get_epivars(x, "id")
}


#' @rdname accessors
#' @export
date_onset <- function(x) {
  get_epivars(x, "date_onset")
}


#' @rdname accessors
#' @export
date_report <- function(x) {
  get_epivars(x, "date_report")
}


#' @rdname accessors
#' @export
date_outcome <- function(x) {
  get_epivars(x, "date_outcome")
}


#' @rdname accessors
#' @export
case_definition <- function(x) {
  get_epivars(x, "case_definition")
}


#' @rdname accessors
#' @export
outcome <- function(x) {
  get_epivars(x, "outcome")
}


#' @rdname accessors
#' @export
gender <- function(x) {
  get_epivars(x, "gender")
}


#' @rdname accessors
#' @export
age <- function(x) {
  get_epivars(x, "age")
}


#' @rdname accessors
#' @export
age_group <- function(x) {
  get_epivars(x, "age_group")
}


#' @rdname accessors
#' @export
geo <- function(x) {
  get_epivars(x, c("geo_lon", "geo_lat"))
}
