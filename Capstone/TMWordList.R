library(tm)
library(stringr)
library(SnowballC)
library(tau)


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

applyTransformations <- function(corpus, language = "english") {
  file.name <- str_c("./lib/profanities_",language,".txt")
  profanities <- readFileLines(file.name)
  print(str_c("Running transformations on ", language, " corpus"))
  corpus <- tm_map(corpus, FUN = removeWords, profanities)
  corpus <- tm_map(corpus, FUN = removeWords, stopwords("english"))
  corpus <- tm_map(corpus, FUN = removePunctuation)
  corpus <- tm_map(corpus, FUN = stemDocument)
  corpus <- tm_map(corpus, FUN = stripWhitespace)
  corpus <- tm_map(corpus, FUN = content_transformer(tolower))
  #corpus <- tm_map(corpus, FUN = tolower)
  return(corpus)
}

#source.dir <- "./Coursera-SwiftKey/final/en_US/"
source.dir <- "./extracts"

print(str_c("Reading corpus from directory: ", source.dir))
en_docs <- Corpus(DirSource(directory = source.dir, pattern = ".txt"),
                  readerControl = list(reader = readPlain,
                                       language = "english",
                                       load = TRUE))
en_docs <- applyTransformations(en_docs)

# Consider looking up synonyms

print(en_docs)

