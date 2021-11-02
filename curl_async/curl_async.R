library("curl")

url <- c(
  "https://www.google.com",
  "https://cloud.r-project.org",
  "https://httpbin.org/blabla",
  "https://httpbin.org/blablabla"
)

res <- vector("list", length(url))
names(res) <- url
done <- function(req) {
  name <- req[["url"]]
  res[[name]] <<- req
  cat("done\n")
}
handle <- function() {
  new_handle(nobody = TRUE) # request header but not body
}
pool <- new_pool(total_con =, host_con =) # control concurrency
for (i in seq_along(url)) {
  curl_fetch_multi(url[i], done = done, handle = handle(), pool = pool)
}
zz <- multi_run(timeout = getOption("timeout"), poll = FALSE, pool = pool)

vapply(res[[1L]], typeof, "")
vapply(res, `[[`, 0L, "status_code")
vapply(res, function(req) rawToChar(req[["content"]]), "") # no body
