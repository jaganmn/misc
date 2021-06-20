## @param f function
## @return `TRUE` if `f` is an identity function, `FALSE` otherwise
is_identity <- function(f) {
  a <- names(formals(f))
  length(a) > 0L && is.name(b <- body(f)) && b == as.name(a)
}

## @param p package name as string
## @return named list of functions in namespace
get_func_list <- function(p) {
  ns <- getNamespace(p)
  fn <- lsf.str(envir = ns)
  mget(fn, envir = ns, mode = "function", inherits = FALSE)
}

## @param p package name as string
## @return character vector listing names of identity functions
get_identity_names <- function(p) {
  fl <- get_func_list(p)
  names(fl)[vapply(fl, is_identity, NA)]
}

(pp <- c("base", getOption("defaultPackages")))
id <- sapply(pp, get_identity_names, simplify = FALSE)
id[lengths(id) > 0L]
sum(lengths(id))
