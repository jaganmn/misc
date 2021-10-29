pkgname <- "foo"
usethis::create_package(pkgname, rstudio = FALSE, open = FALSE)
setwd(pkgname)
usethis::use_directory("inst", ignore = FALSE)
text <- "#' @title A title
#' @description A description.
#' @param a,b Arguments.
#' @examples
#' x <- add(1, 1)
#' @export
add <- function(a, b) a + b
"
cat(text, file = file.path("R", "add.R"))
roxygen2::roxygenize(".")
pkgload::load_all(".")

setwd("..")
unlink(pkgname, recursive = TRUE)
