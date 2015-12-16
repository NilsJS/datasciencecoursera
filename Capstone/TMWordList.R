library(tm)

#txt <- system.file("texts", "txt", package="tm")
#source.dir <- "./Coursera-SwiftKey/final/en_US/"
source.dir <- "./extracts"

docs <- Corpus(DirSource(directory = source.dir, pattern = ".txt"),
               readerControl = list(reader = readPlain,
                                    language = "en-us",
                                    load = TRUE))
docs <- tm_map(docs, FUN = removePunctuation)
docs <- tm_map(docs, FUN = stripWhitespace)