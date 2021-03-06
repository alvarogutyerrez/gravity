#' @title Left-censored Tobit model with known threshold
#'
#' @description \code{tobit} estimates gravity models in their additive form
#' by conducting a left-censored regression, which, after adding the
#' constant \code{1} to the dependent variable, utilizes \code{log(1) = 0}
#' as the censoring value.
#'
#' @details \code{tobit} represents the left-censored tobit \insertCite{Tobin1958;textual}{gravity}
#' approach utilizing a known censoring threshold
#' which is often used when several gravity models are compared.
#'
#' When taking the log of the gravity equation flows equal to zero
#' constitute a problem as their log is not defined.
#'
#' Therefore, in the execution of the function the number \code{1}
#' is added to all flows and the \code{log(flows+1)} is
#' taken as the dependent variable.
#'
#' The tobit estimation is conducted using the \code{\link[censReg]{censReg}}
#' function and setting the lower bound equal to \code{0} as
#' \code{log(1)=0} represents the smallest flows in the transformed
#' variable.
#'
#' A tobit regression represents a combination of a binary and a
#' linear regression.
#'
#' This procedure has to be taken into consideration when
#' interpreting the estimated coefficients.
#'
#' The marginal effects of an explanatory variable on the expected value of
#' the dependent variable equals the product of both the probability of the
#' latent variable exceeding the threshold and the marginal effect of the
#' explanatory variable of the expected value of the latent variable.
#'
#' The function is designed for cross-sectional data,
#' but can be easily extended to panel data using the
#' \code{\link[censReg]{censReg}} function.
#'
#' A robust estimations is not implemented to the present
#' as the \code{\link[censReg]{censReg}} function is not
#' compatible with the \code{\link[sandwich]{vcovHC}} function.
#'
#' For a more elaborate Tobit function, see \code{\link[gravity]{ek_tobit}}
#' for the Eaton and Kortum (2001) Tobit model where each zero trade volume
#' is assigned a country specific interval with the upper
#' bound equal to the minimum positive trade level of the respective
#' importing country.
#'
#' @param dependent_variable name (type: character) of the dependent variable in the dataset
#' \code{data} (e.g. trade flows).
#'
#' The number \code{1} is added and the transformed variable is logged and
#' taken as the dependent variable in the tobit estimation with lower bound
#' equal to \code{0} as \code{log(1) = 0} represents the smallest flows
#' in the transformed variable.
#'
#' @param regressors name (type: character) of the regressors to include in the model.
#'
#' Include the distance variable in the dataset \code{data} containing a measure of
#' distance between all pairs of bilateral partners and bilateral variables that should
#' be taken as the independent variables in the estimation.
#'
#' The distance is logged automatically when the function is executed.
#'
#' Unilateral metric variables such as GDPs can be added but those variables have to be logged first.
#'
#' Interaction terms can be added.
#'
#' Write this argument as \code{c(distance, contiguity, common curreny, ...)}.
#'
#' @param added_constant scalar (type: numeric); represents
#' the constant to be added to the dependent variable. The default value
#' is \code{1}.
#'
#' The minimum of \code{log(y + added_constant)} is taken as the
#' left boundary in the Tobit model.
#'
#' In the often used case of \code{added_constant = 1}, the
#' dependent variable is left-censored at value \code{0}
#' as \code{log(1) = 0}.
#'
#' @param data name of the dataset to be used (type: character).
#'
#' To estimate gravity equations you need a square dataset including bilateral
#' flows defined by the argument \code{dependent_variable}, ISO codes or similar of type character
#' (e.g. \code{iso_o} for the country of origin and \code{iso_d} for the
#' destination country), a distance measure defined by the argument \code{distance}
#' and other potential influences (e.g. contiguity and common currency) given as a vector in
#' \code{regressors} are required.
#'
#' All dummy variables should be of type numeric (0/1).
#'
#' Make sure the ISO codes are of type "character".
#'
#' If an independent variable is defined as a ratio, it should be logged.
#'
#' The user should perform some data cleaning beforehand to remove observations that contain entries that
#' can distort estimates.
#'
#' The function allows zero flows but will remove zero distances.
#'
#' @param ... additional arguments to be passed to \code{tobit}.
#'
#' @references
#' For more information on gravity models, theoretical foundations and
#' estimation methods in general see
#'
#' \insertRef{Anderson1979}{gravity}
#'
#' \insertRef{Anderson2001}{gravity}
#'
#' \insertRef{Anderson2010}{gravity}
#'
#' \insertRef{Baier2009}{gravity}
#'
#' \insertRef{Baier2010}{gravity}
#'
#' \insertRef{Head2010}{gravity}
#'
#' \insertRef{Santos2006}{gravity}
#'
#' and the citations therein.
#'
#' Especially for Tobit models see
#'
#' \insertRef{Tobin1958}{gravity}
#'
#' \insertRef{Eaton1995}{gravity}
#'
#' \insertRef{Eaton2001}{gravity}
#'
#' \insertRef{Carson2007}{gravity}
#'
#' See \href{https://sites.google.com/site/hiegravity/}{Gravity Equations: Workhorse, Toolkit, and Cookbook} for gravity datasets and Stata code for estimating gravity models.
#'
#' @examples
#' \dontrun{
#' # Example for data with zero trade flows
#' data(gravity_zeros)
#'
#' gravity_zeros <- gravity_zeros %>%
#'     mutate(
#'         lgdp_o = log(gdp_o),
#'         lgdp_d = log(gdp_d)
#'     )
#'
#' tobit(dependent_variable = "flow", regressors = c("distw", "rta", "lgdp_o", "lgdp_d"),
#' added_constant = 1, data = gravity_zeros)
#' }
#'
#' \dontshow{
#' # examples for CRAN checks:
#' # executable in < 5 sec together with the examples above
#' # not shown to users
#'
#' data(gravity_zeros)
#' gravity_zeros$lgdp_o <- log(gravity_zeros$gdp_o)
#' gravity_zeros$lgdp_d <- log(gravity_zeros$gdp_d)
#'
#' # choose exemplarily 10 biggest countries for check data
#' countries_chosen_zeros <- names(sort(table(gravity_zeros$iso_o), decreasing = TRUE)[1:10])
#' grav_small_zeros <- gravity_zeros[gravity_zeros$iso_o %in% countries_chosen_zeros,]
#' tobit(dependent_variable = "flow", regressors = c("distw", "rta","lgdp_o","lgdp_d"),
#' added_constant = 1, data = grav_small_zeros)
#' }
#'
#' @return
#' The function returns the summary of the estimated gravity model as a
#' \code{\link[censReg]{censReg}}-object.
#'
#' @seealso \code{\link[censReg]{censReg}}
#'
#' @export

tobit <- function(dependent_variable, regressors, added_constant = 1, data, ...) {
  # Checks ------------------------------------------------------------------
  stopifnot(is.data.frame(data))
  stopifnot(is.character(dependent_variable), dependent_variable %in% colnames(data), length(dependent_variable) == 1)
  stopifnot(is.character(regressors), all(regressors %in% colnames(data)), length(regressors) > 1)
  stopifnot(is.numeric(added_constant), length(added_constant) == 1)

  # Split input vectors -----------------------------------------------------
  distance <- regressors[1]
  additional_regressors <- regressors[-1]

  # Discarding unusable observations ----------------------------------------
  d <- data %>%
    filter_at(vars(!!sym(distance)), any_vars(!!sym(distance) > 0)) %>%
    filter_at(vars(!!sym(distance)), any_vars(is.finite(!!sym(distance))))

  # Transforming data, logging distances ---------------------------------------
  d <- d %>%
    mutate(
      dist_log = log(!!sym(distance))
    )

  # Transforming data, logging flows -------------------------------------------
  d <- d %>%
    rowwise() %>%
    mutate(y_cens_log_tobit = log(sum(!!sym(dependent_variable), added_constant, na.rm = TRUE))) %>%
    ungroup()

  ypc_log_min <- min(d %>% select(!!sym("y_cens_log_tobit")), na.rm = TRUE)

  # Model ----------------------------------------------------------------------
  vars <- paste(c("dist_log", additional_regressors), collapse = " + ")
  form <- stats::as.formula(paste("y_cens_log_tobit", "~", vars))
  model_tobit <- censReg::censReg(
    formula = form,
    left = ypc_log_min,
    right = Inf,
    data = d,
    start = rep(0, 2 + length(regressors)),
    method = "BHHH"
  )

  # Return ---------------------------------------------------------------------
  return_object <- summary(model_tobit)
  return_object$call <- form
  return(return_object)
}
