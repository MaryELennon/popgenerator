#' generate_horizontal_relations
#' 
#' Generate relations between random individuals.
#'
#' @param settings relations_settings object
#'
#' @return relations data.frame (every row contains one relation)
#'
#' @export
generate_horizontal_relations <- function(settings) {

  population_by_unit <- split(settings@population, settings@population$unit)
  
  relations_by_unit <- lapply(
    population_by_unit,
    function(population) {
  
      humans <- population$id
      
      from_index <- rep(1:(length(humans)), each = settings@amount_friends)
      
      shift <- rep(      
        get_average_index_shift_vector(
          x = population$birth_time, age_shift = 50, moving_average_looking_range = 5, sides = 2
        ),
        each = settings@amount_friends
      )
      shift <- rlang::prepend(shift, rep(shift[1], settings@amount_friends))
      
      to_index <- floor(
        stats::runif(
          length(from_index), 
          min = from_index - shift, 
          max = from_index + shift
        )
      )
      from_index <- from_index[!(to_index < 1 | to_index > length(humans))]
      to_index <- to_index[!(to_index < 1 | to_index > length(humans))]

      horizontal_relations <- tibble::tibble(
        from = humans[from_index], 
        to = humans[to_index],
        unit = population$unit[1],
        type = "friend"
      )

      return(horizontal_relations)
    }
  )
  
  all_relations <- do.call(rbind, relations_by_unit)

  return(all_relations)

}
