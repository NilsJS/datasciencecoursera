library(tm)
library(stringr)
library(SnowballC)
library(tau)


readFileLines = function(file.name, num.lines = -1) {
  print(str_c("Reading file: ", file.name))
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

readCorpus <- function(dir, language = "english") {
  print(str_c("Reading corpus from directory: ", source.dir))
  return(Corpus(DirSource(directory = source.dir, pattern = ".txt"),
                readerControl = list(reader = readPlain,
                                     language = language,
                                     load = TRUE)))
}

applyTransformations <- function(corpus, language = "english") {
  profanity.file.name <- str_c("./lib/profanities_",language,".txt")
  profanities <- readFileLines(profanity.file.name)

  print(str_c("Applying transformations on '", language, "' corpus"))
  return(tm_map(tm_map(tm_map(tm_map(tm_map(
         corpus, 
         FUN = removeWords, stopwords(language)), 
         FUN = removeWords, profanities),
         FUN = stemDocument),
         FUN = removeNumbers),
         FUN = content_transformer(tolower)))
#  FUN = removePunctuation)
#  FUN = stripWhitespace)
}

getTermMatrix <- function(corpus) {
  return(TermDocumentMatrix(corpus))
}

getTermFreq <- function(term.matrix, low.freq = 0, high.freq = Inf) {
  return(findFreqTerms(term.matrix, lowfreq = low.freq, highfreq = high.freq))
}