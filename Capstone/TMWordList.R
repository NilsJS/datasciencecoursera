require(tm)
require(stringr)
require(SnowballC)
require(tau)
require(class)
require(data.table)
require(RWeka)


readFileLines = function(file.name, num.lines = -1, format = "UTF-8") {
  print(str_c("Reading file: ", file.name))
  con <- file(file.name, "r", encoding = format) 
  lines <- readLines(con, num.lines)
  close(con)
  return(lines)
}

readAndTransformFile <- function(file.name, profanities, stopwrds, num.lines = -1) {
  print(str_c("Reading file for tranfomation: ", file.name))
  con <- file(file.name, "r") 
  ln <- 0
  lines <- list()
  line <- readLines(con, 1, encoding = "UTF-8")
  while (!is.null(line) & length(line) > 0 & (num.lines < 0 | ln < num.lines)) {
    ln <- ln + 1
    
    # Transform line
    line <- removeWords(line, stopwrds)
    line <- removeWords(line, profanities)
    line <- removeNumbers(line)
    line <- tolower(line) 
    line <- stemDocument(line)
    line <- stripWhitespace(line)
    line <- removePunctuation(line)
      
    lines[ln] <- line
    line <- readLines(con, 1)
  }
  close(con)
  return(lines)
}

readAndTransformCorpus <- function(dir.name, language = "english"){
  #  List of profanities
  profane.custom <- readFileLines(str_c("./lib/profanities_",language,".txt"))
  offensive.1 <- readFileLines("./scowl-2015.08.24/misc/offensive.1")
  offensive.2 <- readFileLines("./scowl-2015.08.24/misc/offensive.2")
  profane.1 <- readFileLines("./scowl-2015.08.24/misc/profane.1")
  profane.3 <- readFileLines("./scowl-2015.08.24/misc/profane.3")
  profanities <- c(offensive.1, offensive.2, profane.1, profane.3, profane.custom)
  # Stopwords
  sw <- stopwords(language)

  file.names <- list.files(path=dir.name, full.names = TRUE)
  corpus <- list()  # Corpus is just a list of line lists
  for(fn in file.names) {
    corpus[fn] <- list(readAndTransformFile(fn, profanities, sw))
  }

  return(corpus)
}



readCorpus <- function(dir, language = "english") {
  print(str_c("Reading corpus from directory: ", source.dir))
  return(Corpus(DirSource(directory = source.dir, pattern = ".txt"),
                readerControl = list(reader = readPlain,
                                     language = language,
                                     load = TRUE)))
}

applyTransformations <- function(corpus, language = "english") {
  print("Reading profanities...")
  profane.custom <- readFileLines(str_c("./lib/profanities_",language,".txt"))
  offensive.1 <- readFileLines("./scowl-2015.08.24/misc/offensive.1")
  offensive.2 <- readFileLines("./scowl-2015.08.24/misc/offensive.2")
  profane.1 <- readFileLines("./scowl-2015.08.24/misc/profane.1")
  profane.3 <- readFileLines("./scowl-2015.08.24/misc/profane.3")
  
  profanities <- c(offensive.1, offensive.2, profane.1, profane.3, profane.custom)
  
  print(str_c("Applying transformations on '", language, "' corpus"))
  return(tm_map(tm_map(tm_map(tm_map(tm_map(tm_map(tm_map(
         corpus, 
         FUN = removeWords, stopwords(language)), 
         FUN = removeWords, profanities),
         FUN = stemDocument),
         FUN = removeNumbers),
         FUN = stripWhitespace),
         FUN = removePunctuation),
         FUN = content_transformer(tolower)))
#  FUN = removePunctuation)
}

getTermMatrix <- function(corpus) {
  return(TermDocumentMatrix(corpus))
}

getTermFreq <- function(term.matrix, low.freq = 0, high.freq = Inf) {
  return(findFreqTerms(term.matrix, lowfreq = low.freq, highfreq = high.freq))
}

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))

getBigramTDM <- function(corpus) {
  # get all 1-gram and 2-gram word counts
  return(TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer, 
                                                   stopwords = TRUE)))
}

TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))

getTrigramTDM <- function(corpus) {
  # get all 1-gram and 2-gram word counts
  return(TermDocumentMatrix(corpus, control = list(tokenize = TrigramTokenizer)))
}

# convert to data.table
convertTDMtoDataTable <- function(tdm) {
  dt <- as.data.table(as.data.frame(as.matrix(tdm)), keep.rownames=TRUE)
  setkey(dt, rn)
  return (dt)
}




