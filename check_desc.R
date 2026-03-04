desc <- read.dcf("DESCRIPTION")
cat("Authors@R field:\n")
cat(desc[,"Authors@R"], "\n")
tryCatch(
  eval(parse(text=desc[,"Authors@R"])),
  error=function(e) cat("PARSE ERROR:", conditionMessage(e), "\n")
)
