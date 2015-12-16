library(tm)
library(stringr)

#source.dir <- "./Coursera-SwiftKey/final/en_US/"
source.dir <- "./extracts"

print(str_c("Reading corpus from directory: ", source.dir))
docs <- Corpus(DirSource(directory = source.dir, pattern = ".txt"),
               readerControl = list(reader = readPlain,
                                    language = "en-us",
                                    load = TRUE))

print("Reading profanity dictionary")
readFileLines = function(file.name, num.lines = -1) {
  lines <-vector()
  con <- file(file.name, "r") 
  ln <- 0
  line <- readLines(con, 1)
  while (!is.null(line) & length(line) > 0 & (num.lines < 0 | ln < num.lines)) {
    ln <- ln + 1
    lines[ln] <- line
    line <- readLines(con, 1)
  }
  close(con)
  return(lines)
}
profanities <- readFileLines("./lib/profanities2.txt")

print("Running transformations on corpus")
docs <- tm_map(docs, FUN = removeWords, profanities)
docs <- tm_map(docs, FUN = removePunctuation)
docs <- tm_map(docs, FUN = stripWhitespace)

#docs <- tm_map(docs, FUN = tolower)

print(docs)

