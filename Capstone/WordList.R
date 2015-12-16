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

WordList <- function(file.name)
{
  ## Get the environment for this
  ## instance of the function.
  thisEnv <- environment()
  
  words <- list()
  fileName <- file.name
  
  me <- list(
    ## Define the environment where this list is defined so
    ## that I can refer to it later.
    thisEnv = thisEnv,
    
    ## Define the accessors for the data fields.
    getEnv = function()
    {
      return(get("thisEnv",thisEnv))
    },
    
    getWords = function()
    {
      #return this$words
      return(get("words",thisEnv))
    },
    
    getFileName = function()
    {
      return(get("fileName",thisEnv))
    },

    processWords = function(w1, w2) {
      words <- get("words",thisEnv)
      print(str_c("Processing words: '", w1, "', '", w2, "'"))
      print(str_c("Current length of word list: ", length(words)))
      w1 <- tolower(w1)
      w2 <- tolower(w2)
      if (is.null(words[[w1]])) {
        print(str_c("New word: '", w1, "'"))
        wl$words[[w1]] <- list()
      }
      if (str_length(w2) > 0){
        if (is.null(words[[w1]][[w2]])) {
          print(str_c("New next word after '", w1, "': '", w2, "'"))
          wl$words[[w1]][[w2]] <- 1
        } else {
          wl$words[[w1]][[w2]] <- wl$words[[w1]][[w2]] + 1
        }
      }
      assign("words", words, thisEnv)
    },
    
    tokenizeLine = function(line) {
      print(str_c("Processing line: '", line, "'"))
      # TODO: Split line in individual sentences
      line.words <- strsplit(line, split="\\W")
      words <- line.words[[1]]
      l <- length(words)
      print(str_c("Length of words: ", l))
      if (l > 1) {
        for (i in 1:l) {
          w1 <- words[i]
          if (str_length(w1) > 0) {
            i2 <- i + 1
            w2 <- ""
            while (i2 < l & str_length(words[i2]) == 0) i2 <- i2 + 1
            if (i2 <= l) w2 <- words[i2]
            if (is.na(w2) | is.null(w2)) w2 <- ""
            get("processWords",thisEnv)(w1, w2)
          }
        }
      }
    },
    
    readFile = function(num.lines = -1) {
      con <- file(fileName, "r") 
      ln <- 0
      line <- readLines(con, 1)
      while (!is.null(line) & (num.lines <0 | ln < num.lines)) {
        ln <- ln + 1
        get("tokenizeLine",thisEnv)(line)
        line <- readLines(con, 1)
      }
      close(con)
    }
  )
  
  ## Define the value of the list within the current environment.
  assign('this', me, envir=thisEnv)

  ## Set the name for the class
  class(me) <- append(class(me),"WordList")
  fileName <- file.name
#  this$readFile(file.name=file.name, num.lines=num.lines)
  return(me)
}

WordList.readFile = function(wl, num.lines = -1) {
  con <- file(wl$getfileName(), "r") 
  ln <- 0
  line <- readLines(con, 1)
  while (!is.null(line) & (num.lines <0 | ln < num.lines)) {
    ln <- ln + 1
    print(line)
    #get("tokenizeLine",thisEnv)(line)
    line <- readLines(con, 1)
  }
  close(con)
}



wl <- WordList("./Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
#wl$readFile(num.lines = 2)