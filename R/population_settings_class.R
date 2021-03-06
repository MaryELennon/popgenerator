#' population_settings class
#'
#' class to store values that should be passed to the population generator
#'
#' @slot time test
#' @slot unit_amount test
#' @slot unit_names test
#' @slot unit_size_functions test
#' @slot age_distribution_function test
#' @slot age_range test
#'
#' @export
setClass(
  Class = "population_settings",
  slots = c(
    time = "numeric",
    unit_amount = "numeric",
    unit_names = "factor",
    unit_size_functions = "list",
    age_distribution_function = "function",
    age_range = "numeric"
  )
)

#' init_population_settings
#'
#' Create population_settings object for every row in the 
#' populations_grid data.frame and add it in an additional
#' column.
#'
#' @param time test
#' @param unit_names test
#' @param unit_size_functions test
#' @param age_distribution_function test
#' @param age_range test
#'
#' @return populations_grid data.frame with additional column 
#' population_settings
#'
#' @export
init_population_settings <- function(
  time,
  unit_names,
  unit_size_functions,
  age_distribution_function,
  age_range
) { 
  
  # create population_settings object
  population_settings <- methods::new(
    "population_settings",
    time =                       time,
    unit_amount =                length(unit_names),
    unit_names =                 unit_names,
    unit_size_functions =        fence_unit_size_functions(unit_size_functions, time),
    age_distribution_function =  age_distribution_function,
    age_range =                  age_range
  )

  return(population_settings)
}

fence_unit_size_functions <- function(unit_size_functions, time) {
  lapply(
    unit_size_functions, function(x) {
      res_function <- function(t) {
        if (t < min(time)) {
          x(min(time))
        } else if (t > max(time)) {
          x(max(time))
        } else {
          x(t)
        }
      }
      return(res_function)
    }
  )
}
