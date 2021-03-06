
#' Create objects based on unnamed command line arguments
#'
#' Create objects in the current environment based on
#' unnamed arguments passed at the command line,
#' or on values supplied via \dots.
#'
#' The behaviour of \code{assign_unnamed} depends the
#' on type of R session it is called from: whether it
#' is a standard interactive session, or whether the
#' session was invoked from the command line, e.g
#' via \code{\link[utils]{Rscript}}. Typically,
#' \code{assign_unnamed} is used iteractively when
#' developing code and via the command line
#' when the code is mature.
#'
#' In an interactive session, \code{assign_unnamed}
#' takes the names and values for the objects
#' from \dots. In a session invoked from the command
#' line, \code{assign_unnamed} takes the names
#' from \dots and the values from unnamed command line
#' arguments. \code{assign_unnamed} tries to coerce values
#' passed at the command line to the same classes as the
#' corresponding value in \dots, raising an error if this
#' cannot be done.
#'
#' The number of unnamed arguments passed at the
#' command line must match the number of name-value
#' pairs in \dots. 
#'
#' @param \dots Names and values for objects.
#' The values must have type logical, integer, numeric,
#' or character.
#' 
#' @return \code{assign_unnamed} returns a named list of objects
#' invisibly, but is usually called for its side effect,
#' which is to create objects in the current environment.
#'
#' @seealso Named values passed at the command line
#' can be processed using function \code{\link{assign_named}}.
#'
#' \code{assign_unnamed} uses function
#' \code{\link[base]{interactive}} to decide
#' whether a function is interactive.
#'
#' @examples
#' ## used interactively ----------------------------------
#' assign_unnamed(outfile = "results.rds",
#'                iter = 100)
#' ls()
#' outfile
#' iter
#' rm(outfile, iter)
#'
#' 
#' ## used in script run from command line ----------------
#'
#' ## create script and place in
#' ## temporary directory
#' txt <- 'library(argfun)
#'         assign_unnamed(outfile = "results.rds",
#'                        iter = 100)
#'         print(ls())
#'         print(outfile)
#'         print(iter)'
#' dir_current <- getwd()
#' setwd(tempdir())
#' cat(txt, file = "myscript.R")
#' ## run script from command line
#' system("Rscript myscript.R output.rds 500")
#' ## tidy up
#' file.remove("myscript.R")
#' setwd(dir_current)
#' @export
assign_unnamed <- function(...) {
    args_dots <- list(...)
    envir <- parent.frame()
    check_args_dots(args_dots, fun_name = "assign_unnamed")
    if (interactive())
        assign_args(args = args_dots, envir = envir)
    else {
        args_cmd <- get_args_cmd_unnamed()
        args_comb <- make_args_comb_unnamed(args_dots = args_dots,
                                            args_cmd = args_cmd)
        assign_args(args = args_comb, envir = envir)
    }
}

