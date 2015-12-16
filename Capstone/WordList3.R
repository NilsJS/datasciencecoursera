# Load libraries
library(dplyr, quietly=TRUE, warn.conflicts = FALSE)
suppressWarnings(library(scales, quietly=TRUE))
suppressWarnings(library(pander, quietly=TRUE))
library(ggplot2)
suppressWarnings(library(gridExtra, quietly=TRUE, warn.conflict=FALSE))
library(lattice)
library(caret)
library(AppliedPredictiveModeling)
suppressPackageStartupMessages(library(randomForest, quietly=TRUE, warn.conflict=FALSE))
library(colorspace)
library(grid)
library(data.table, quietly=TRUE, warn.conflict=FALSE)
suppressPackageStartupMessages(library(VIM, quietly=TRUE, warn.conflict=FALSE))
library(curl)
library(tm)
library(stringr)

word.pairs <- list()

process.word.pair = function(w1, w2) {
  print(str_c("Processing word pair: ['", w1, "','", w2, "']"))
  print(str_c("Current length of word list: ", length(word.pairs)))
  w1 <- tolower(w1)
  w2 <- tolower(w2)
  if (is.null(word.pairs[[w1]])) {
    print(str_c("New word: '", w1, "'"))
    word.pairs[[w1]] <<- list()
  }
  if (str_length(w2) > 0){
    if (is.null(word.pairs[[w1]][[w2]])) {
      print(str_c("New next word after '", w1, "': '", w2, "'"))
      word.pairs[[w1]][[w2]] <<- 1
    } else {
      word.pairs[[w1]][[w2]] <<- word.pairs[[w1]][[w2]] + 1
    }
  }
}
    
tokenize.line = function(line) {
  print(str_c("Tokenizing line: '", line, "'"))
  # TODO: Split line in individual sentences
  line.words <- strsplit(line, split="\\W")
  words <- line.words[[1]]
  l <- length(words)
  if (l > 1) {
    for (i in 1:l) {
      w1 <- words[i]
      if (str_length(w1) > 0) {
        i2 <- i + 1
        w2 <- ""
        while (i2 < l & str_length(words[i2]) == 0) i2 <- i2 + 1
        if (i2 <= l) w2 <- words[i2]
        if (is.na(w2) | is.null(w2)) w2 <- ""
        process.word.pair(w1, w2)
      }
    }
  }
}
    
read.file = function(file.name, num.lines = -1) {
  print(str_c("Reading file: '", file.name, "'"))
  con <- file(file.name, "r") 
  ln <- 0
  line <- readLines(con, 1)
  while (!is.null(line) & (num.lines <0 | ln < num.lines)) {
    ln <- ln + 1
    tokenize.line(line)
    line <- readLines(con, 1)
  }
  close(con)
}

read.file("./Coursera-SwiftKey/final/en_US/en_US.blogs.txt", 2)
