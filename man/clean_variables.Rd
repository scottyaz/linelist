% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_variables.R
\name{clean_variables}
\alias{clean_variables}
\title{Clean variable labels and fix spelling according to a wordlist}
\usage{
clean_variables(x, sep = "_", wordlists = NULL, spelling_vars = 3,
  sort_by = NULL, protect = FALSE, classes = NULL,
  warn_spelling = FALSE)
}
\arguments{
\item{x}{a \code{data.frame}}

\item{sep}{The separator used between words, and defaults to the underscore
\code{_}.}

\item{wordlists}{a data frame or named list of data frames with at least two
columns defining the word list to be used. If this is a data frame, a third
column must be present to split the wordlists by column in \code{x} (see
\code{spelling_vars}).}

\item{spelling_vars}{character or integer. If \code{wordlists} is a data frame,
then this column in defines the columns in \code{x} corresponding to each
section of the \code{wordlists} data frame. This defaults to \code{3}, indicating the
third column is to be used.}

\item{sort_by}{a character the column to be used for sorting the values in
each data frame. If the incoming variables are factors, this determines how
the resulting factors will be sorted.}

\item{protect}{a logical or numeric vector defining the columns to protect
from any manipulation. Note: columns in \code{protect} will override any columns
in either \code{force_Date} or \code{guess_dates}.}

\item{classes}{a vector of class definitions for each of the columns. If this
is not provided, the classes will be read from the columns themselves.
Practically, this is used in \code{\link[=clean_data]{clean_data()}} to mark columns as protected.}

\item{warn_spelling}{if \code{TRUE}, errors and warnings from \code{\link[=clean_spelling]{clean_spelling()}}
will be aggregated and presented for each column that issues them. The
default value is \code{FALSE}, which means that all errors and warnings will be
ignored.}
}
\description{
Clean variable labels and fix spelling according to a wordlist
}
\examples{

## make toy data
toy_data <- messy_data(20)

# location data with mis-spellings, French, and English.
messy_locations <- c("hopsital", "h\\u00f4pital", "hospital", 
                     "m\\u00e9dical", "clinic", 
                     "feild", "field")
toy_data$location <- sample(messy_locations, 20, replace = TRUE)

## show data
toy_data

# clean labels
clean_variables(toy_data) # by default, it's the same as clean_variable_lables

# add a wordlist
wordlist <- data.frame(
  from  = c("hopsital", "hopital",  "medical", "feild"),
  to    = c("hospital", "hospital", "clinic",  "field"),
  variable = rep("location", 4),
  stringsAsFactors = FALSE
)

clean_variables(toy_data, 
                wordlists     = wordlist,
                spelling_vars = "variable"
               )
}
\seealso{
\code{\link[=clean_variable_labels]{clean_variable_labels()}} to standardise text,
\code{\link[=clean_variable_spelling]{clean_variable_spelling()}} to correct spelling with a wordlist.
}
\author{
Zhian N. Kamvar
}
