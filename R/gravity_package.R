#' gravity exported operators and S3 methods
#' The following functions are imported and then re-exported
#' from the gravity package to avoid listing Depends of gravity.
#' @importFrom dplyr select mutate group_by ungroup row_number left_join
#'   ends_with vars filter_at any_vars rowwise rename
#' @importFrom tidyr gather spread
#' @importFrom purrr as_vector
#' @importFrom rlang sym syms
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#' @importFrom survival Surv
#' @importFrom stats lm as.formula glm
#' @importFrom censReg censReg
#' @importFrom Rdpack reprompt
#' @name gravity-exports
#' @keywords internal
NULL