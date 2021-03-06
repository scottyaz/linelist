#' @export
#' @rdname compare_data
#' @param common_values when `TRUE` (default), common values are printed. When `FALSE`, common values are suppressed. 
#' @param diff_only when `TRUE` only differences between ref and the current data content are presented, ignoring similarities. Defaults to `FALSE`.
#'   common values are hidden.
print.data_comparison <- function(x, ..., common_values = TRUE, diff_only = FALSE) {

  cat(
      crayon::bold("\n /// Comparisons of data content // \n")
      )


  ## dimension diagnostics
  if (!is_empty(x$dim)) {
    cat(
        crayon::bold("\n\n // Comparison of dimensions /")
        )
    if (isTRUE(x$dim)) {
      cat(
          crayon::green(
                        "\nSame number of rows and columns")
          )
    } else {
      if (!is_empty(x$dim$n_rows)) {
        cat(sprintf("\n  * different numbers of rows: ref has %d, new data has %d",
                    x$dim$n_rows["ref"],
                    x$dim$n_rows["new"]
                    ))
      }
      if (!is_empty(x$dim$n_columns)) {
        cat(
            crayon::italic(
                           sprintf("\n  * different numbers of columns: ref has %d, new data has %d",
                                   x$dim$n_columns["ref"],
                                   x$dim$n_columns["new"]
                                   ))
            )
      }
      cat("\n")
    }
  }


  ## variable names diagnostics
  if (!is_empty(x$names)) {
    cat(
        crayon::bold("\n\n // Comparison of variable names /\n")
        )
    if (isTRUE(x$names)) {
      cat(
          crayon::green(
                        "\nSame variable names, in the same order")
          )
    } else {
      if (!is_empty(x$names$missing)) {
        cat(
            crayon::italic(
                           "\n  * variables missing in the new data:\n")
            )
        print(x$names$missing)
      }
      if (!is_empty(x$names$new)) {
        cat("\n  * new variables:\n")
        print(x$names$new)
      }
      if (!is_empty(x$names$common) && !diff_only) {
        cat("\n  * variables common to both datesets:\n")
        print(x$names$common)
      }
    }
  }


  ## variable classes diagnostics
  if (!is_empty(x$classes)) {
    cat(
        crayon::bold("\n\n // Comparison of variable classes /\n")
        )
    if (isTRUE(x$classes)) {
      cat(
          crayon::green(
                        "\nSame variable classes")
          )
    } else {
      for (i in seq_along(x$classes)) {
        e <- x$classes[[i]]
        current_variable <- names(x$classes)[i]
        if (length(e) == 1) {
          if (!diff_only) {
            cat(
                crayon::green(
                              sprintf(
                                      "`%s`: same class (%s) \n",
                                      current_variable,
                                      e)
                              )
                )
          }
        } else {
          cat(
              crayon::italic(
                             sprintf("`%s` has changed from `%s` to `%s`\n",
                                     e[1],
                                     e[2],
                                     e[3]))
              )
        }
      }
    }
  }


  ## categorical variable values diagnostics
  if (!is_empty(x$values)) {
    cat(
        crayon::bold("\n\n // Comparison of values in categorical variables /\n")
        )
    if (isTRUE(x$values)) {
      cat(
          crayon::green(
                        "\nSame values for categorical variables")
          )
    }
    for (i in seq_along(x$values)) {
      e <- x$values[[i]]
      current_variable <- names(x$values)[i]
      if (isTRUE(e)) {
        if (!diff_only) {
          cat(
              crayon::green(
                            sprintf("\n`%s`: same variable values",
                                    current_variable))
              )
        }
      } else {
        if (!is_empty(e$missing)) {
          cat(
              crayon::italic(
                             sprintf(
                                     "\n  * Missing values in `%s`:\n",
                                     current_variable))
              )
          print(e$missing)
        }
        if (!is_empty(e$new)) {
          cat(
              crayon::italic(
                             sprintf(
                                     "\n  * New values in `%s`:\n",
                                     current_variable))
              )
          print(e$new)
        }
        if (!is_empty(e$common) && !diff_only) {
          cat(
              crayon::italic(
                             sprintf(
                                     "\n  * `%s`, values common to both datasets:\n",
                                     current_variable))
              )
          if (common_values) {
            print(e$common)
          } else {
            cat(sprintf("\t%d value(s) [hidden]", length(e$common)))
          }
        }

      }
    }
  }

  cat("\n")  
}
