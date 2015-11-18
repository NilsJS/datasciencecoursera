---
title       : Coursera Data Products
subtitle    : Course Project Pitch
author      : Nils Sand�y
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Shiny Application

1. Write a shiny application with associated supporting documentation. The documentation should be thought of as whatever a  user will need to get started using your application.
2. Deploy the application on Rstudio's shiny server
3. Share the application link by pasting it into the text box below
4. Share your server.R and ui.R code on github

The application must include the following:

1. Some form of input (widget: textbox, radio button, checkbox, ...)
2. Some operation on the ui input in sever.R
3. Some reactive output displayed as a result of server calculations
4. You must also include enough documentation so that a novice user could use your application.
5. The documentation should be at the Shiny website itself. Do not post to an external link.

The Shiny application in question is entirely up to you. However, if you're having trouble coming up with ideas, you could start from the simple prediction algorithm done in class and build a new algorithm on one of the R datasets packages. Please make the package simple for the end user, so that they don't need a lot of your prerequisite knowledge to evaluate your application. You should emphasize a simple project given the short time frame.  

--- .class #id 

## Evaluation Criteria for Application

- Provide constructive feedback to the student who submitted the work. Point out the strengths of their application, and give them advice about how it could be improved in the future.  
- Was there enough documentation on the shiny site for a user to get started using the application?
- Did the application run as described in the documentation?
- Was there some form of widget input (slider, textbox, radio buttons, checkbox, ...) in either ui.R or a custom web page?
- Did server.R perform some calculations on the input in server.R?
- Was the server calculation displayed in the html page?
- Was the app substantively different than the very simple applications built in the class? Note, it's OK if the app is simple and based on the one presented in class, I just don't want it to be basically a carbon copy of the examples we covered. As an example, if someone simply changed the variable names, then this would not count. However, a prediction algorithm that had a similar layout would be fine.
- Here's your opportunity to give the app +1 for being well done, or neat, or even just a solid effort.
- If any of your grading decisions require explanation, please note your explanations here.  

---

## Project Pitch

You get 5 slides (inclusive of the title slide)  to pitch a your app. You're going to create a web page using Slidify or Rstudio Presenter with an html5 slide deck.

Here's what you need

1. 5 slides to pitch our idea done in Slidify or Rstudio Presenter
2. Your presentation pushed to github or Rpubs
3. A link to your github or Rpubs presentation pasted into the text box below

Your presentation must satisfy the following

1. It must be done in Slidify or Rstudio Presenter
2. It must be 5 pages
3. It must be hosted on github or Rpubs
4. It must contained some embedded R code that gets run when slidifying the document

Notice to publish your slidify presentation to github or Rpubs, there's the publish command. This link outlines how to do it (it's one line). 

http://slidify.org/publish.html

Rstudio presenter has a button to publish directly to Rpubs https://support.rstudio.com/hc/en-us/articles/200714023-Displaying-and-Distributing-Presentations. If you are using Rpubs, put in the link to the presentation into the submission box as a http:// link not a https:// link.

You can also publish using both formats to github manually using gh-pages, though your github branch must have a .nojekyll fle and be on a branch names gh-pages. There's more on gh-pages here https://pages.github.com/  and there is a video lecture outlining how to do this.

---

## Evaluation Criteria for project pitch

- Was the presentation completed in slidify or R Presenter?
- Was it 5 pages?
- Did it contain an R expression that got evaluated and displayed?
- Was it hosted on github or Rpubs?
- Was the presentation actually a presentation? (I.e. it had a legitimate pitch for the shiny application?)
- Here's your opportunity to give this presentation a +1 for being well done. Did they tinker around with the default style? Was the presentation particularly lucid and well organized? In other words, the student made a legitimate try.
- There were no R errors displayed in the presentation.
- If any of your grading decisions require explanation, please note your explanations here.




