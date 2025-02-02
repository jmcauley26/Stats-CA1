library(shiny)
library("ggpubr")

shinyServer(function(input, output){
  
  #Descriptive Analytics - summary 
  output$headeriris <- renderPrint({
    summary(iris)
  })
  output$headerwb <- renderPrint({
    summary(warpbreaks)
  })
  output$headermt <- renderPrint({
    summary(mtcars)
  })
  output$headerfait <- renderPrint({
    summary(faithful)
  })
  output$headerbeav1 <- renderPrint({
    summary(beaver1)
  })
  output$headerbeav2 <- renderPrint({
    summary(beaver2)
  })
  
  #Descriptive Analytics - Graphs 
  
  # IRIS
  output$plot1 <- renderPlot({
    ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species))  +
      geom_point(aes(size = Species, shape = Species)) 
  })
  output$plot2 <- renderPlot({
    ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) + 
      geom_point(aes(size = Species, shape = Species)) 
  })
  
  # WARPBREAKS
  output$plotwb <- renderPlot({
    ggboxplot(warpbreaks, x = "wool", y = "breaks",
              color = "wool",
              palette = c("blue", "red"))
  })
  output$plotwb1 <- renderPlot({
    ggboxplot(warpbreaks, x = "tension", y = "breaks",
              color = "tension",
              palette = c("orangered4", "mediumorchid3","indianred1"))
  })
  
  #MTCARS
  output$plotmt <- renderPlot({
    data<-mtcars[,c(1,3,4,5,6)]
    pairs(data)
  })
  
  #FAITHFUL
  output$plotfaith <- renderPlot({
    ggplot(faithful, aes(x = waiting, y = ..density..)) + 
      geom_histogram(alpha = 0.3, col = "black" ,fill = "blueviolet") + geom_density(size =1.5 , color = "blue") + ggtitle("Waiting Time(min) to Next Eruption")
  })
  
  #Code for graphing beavers taken from r help 
  #BEAVERS
  output$plotbeavers<- renderPlot({
    require(graphics)
    (yl <- range(beaver1$temp, beaver2$temp))
    beaver.plot <- function(bdat, ...) {
      nam <- deparse(substitute(bdat))
      with(bdat, {
        # Hours since start of day:
        hours <- time %/% 100 + 24*(day - day[1]) + (time %% 100)/60
        plot (hours, temp, type = "l", ...,
              main = paste(nam, "body temperature"))
        abline(h = 37.5, col = "gray", lty = 2)
        is.act <- activ == 1
        points(hours[is.act], temp[is.act], col = 2, cex = .8)
      })
    }
    op <- par(mfrow = c(2, 1), mar = c(3, 3, 4, 2), mgp = 0.9 * 2:0)
    beaver.plot(beaver1, ylim = yl)
    beaver.plot(beaver2, ylim = yl)
    par(op)
  })
  
  output$histogram <- renderPlot({
    # CYLINDER
    if (input$variable == 'cyl') {
      # Create the dataset for calculation
      set.seed(length(mtcars$cyl))
      k <- length(which(mtcars$cyl == input$cyl))
      Data = rhyper(length(mtcars$cyl), k, length(mtcars$cyl) - k, input$j)
      
      # Put data into table format
      tab = table(Data)
      
      # Plot said table
      barplot(
        tab,
        col = 'darkslateblue',
        border = NA,
        main = c(
          "Probability of getting (a) cars from sample: ",
          round(dhyper(
            input$a, k, length(mtcars$cyl) - k, input$j
          ), 3)
        )
      )
    }
    if (input$variable == 'gear') {
      # Create the dataset for calculation
      set.seed(length(mtcars$gear))
      k <- length(which(mtcars$gear == input$gear))
      Data = rhyper(length(mtcars$gear), k, length(mtcars$gear) - k, input$j)
      # Put data into table format
      tab = table(Data)
      # Plot said table
      barplot(
        tab,
        col = 'darkslateblue',
        border = NA,
        main = c(
          "Probability of getting (a) cars from sample: ",
          round(dhyper(
            input$a, k, length(mtcars$gear) - k, input$j
          ), 3)
        )
      )
    }
    if (input$variable == 'carb') {
      # Create the dataset for calculation
      set.seed(length(mtcars$carb))
      k <- length(which(mtcars$carb == input$carb))
      Data = rhyper(length(mtcars$carb), k, length(mtcars$carb) - k, input$j)
      # Put data into table format
      tab = table(Data)
      # Plot said table
      barplot(
        tab,
        col = 'darkslateblue',
        border = NA,
        main = c(
          "Probability of getting (a) cars from sample: ",
          round(dhyper(
            input$a, k, length(mtcars$carb) - k, input$j
          ), 3)
        )
      )
    }
    output$prob <- renderPrint({
      print(paste('Selected Variable :', input$variable))
    })
  })
  
  #Exp Probability Model - Faithful
  output$Expprob <- renderPrint({
    lamda1<-mean(faithful$waiting)
    prob <- ppois(input$X,lamda1)
    print(prob)
  })
  output$ExpX <- renderPrint({
    lamda1<- mean(faithful$waiting)
    pred1=mean(rpois(1000,lamda1)) 
    print(pred1)
  })
  output$plotexp <- renderPlot ({
    par(mfrow=c(1,2)) 
    lower <- floor(qexp(0.001, rate=0.2))
    t <- seq(lower,input$max2,0.1)
    plot(t,pexp(t,input$lam1),type='b', main = "Plot of CDF")
    x1=0:input$max2  
    y1=dexp(x1,input$lam1)  
    plot(x1,y1,type='b', main = "pdf exp")
  })
  
  #Poisson Probability Model - warpbreaks
  output$Poisprob <- renderPrint({
    lamda1<- mean(warpbreaks$breaks)
    prob <- ppois(input$Y,lamda1)
    print(prob)
  })
  output$PoisX <- renderPrint({
    lamda1<- mean(warpbreaks$breaks)
    pred1=mean(rpois(1000,lamda1)) 
    print(pred1)
  })
  output$plotpois <- renderPlot ({
    par(mfrow=c(1,2))
    x1=0:input$max1
    y1=dpois(x1,input$lam)  
    plot(x1, ppois(x1, input$lam), type = "b", ylab = "F(x)", main = "Poisson CDF")
    plot(x1,y1,type='b', main = "pdf poisson")
  })
  
  #summary output created, retuning summ of mtcars$mpg variable
  output$summary <- renderPrint({
    summary(mtcars$mpg)
  })
  
  #pnorm function used to calculate difference from two input figures, returning result using print function
  output$normprob <- renderPrint({
    probability <- pnorm(input$upper,mean = mean(mtcars$mpg), sd = sd(mtcars$mpg)) - pnorm(input$lower,mean = mean(mtcars$mpg), sd = sd(mtcars$mpg))
    print(probability)
  })
  
  normal = function(lower,upper){
    mean = mean(mtcars$mpg)
    standarddev = sd(mtcars$mpg)
    t <- seq(-3,3,length=50)*standarddev + mean
    hx <- dnorm(t,mean,standarddev)
    plot(t, hx, type="n", ylab="",
         main="Normal Distribution of mtcars", axes=FALSE)
    i <- t >= lower & t <= upper
    lines(t, hx)
    polygon(c(lower,t[i],upper), c(0,hx[i],0), col="purple")
    chart <- pnorm(upper, mean(mtcars$mpg), sd(mtcars$mpg)) - pnorm(lower, mean(mtcars$mpg), sd(mtcars$mpg))
    result <- paste("Prob(",lower,"< x <",upper,") =",
                    signif(chart, digits=3))
    mtext(result,3)
    axis(1, at=seq(mean-4*standarddev, mean+4*standarddev, standarddev), pos=0) 
  } 
  output$map = renderPlot({normal(input$lower,input$upper)
  })
  
  #Hypothesis Test - One Pop
  output$MeanHyp <- renderPrint({
    x = iris[,as.numeric(input$iv)]
    mean = mean(x)
    sd = sd(x)
    print(paste('Mean:', mean))
    print(paste('Standard Deviation:', sd))
  })
  
  output$ttest1 <- renderPrint({
    x = iris[,as.numeric(input$iv)]
    t <- t.test(x,mu=input$mu,alternative = input$testtype)
    print(t)
  })
  
  output$hypresult <- renderPrint({
    x = iris[,as.numeric(input$iv)]
    t <- t.test(x,mu=input$mu,alternative = input$testtype)
    if(t$p.value<as.numeric(input$Alpha)){
      decision = "reject H_o"}else{
        decision = "accept H_o"
      }
    print(decision)
  })
  
  #Hypothesis Test - Two Pop
  
  output$HypS1 <- renderPrint({
    observations1 = nrow(beaver1)
    mean1 = mean(beaver1$temp)
    sd1 = sd(beaver1$temp)
    print(paste('Observations:', observations1))
    print(paste('Mean:', mean1))
    print(paste('Standard Deviation:', sd1))
  })
  
  output$HypS2 <- renderPrint({
    observations2 = nrow(beaver2)
    mean2 = mean(beaver2$temp)
    sd2 = sd(beaver2$temp)
    print(paste('Observations:', observations2))
    print(paste('Mean:', mean2))
    print(paste('Standard Deviation:', sd2))
  })
  
  output$ttest <- renderPrint({
    welch.test <- t.test(beaver1$temp, beaver2$temp,alternative = input$testtype1)
    welch.test
  })
  
  output$hyp2result <- renderPrint({
    welch.test <- t.test(beaver1$temp, beaver2$temp,alternative = input$testtype1)
    if (welch.test$p.value < as.numeric(input$Alpha1)) {
      decision2 = "reject H_o"
    } else{
      decision2 = "accept H_o"
    }
    print(decision2)
  })
  
  ###############################################################################################################
  #Chi Square Plot
  
  output$chiPlot <- renderPlot({
    chi.values <- seq(0, 25, .1)
    plot(
      x = chi.values,
      y = dchisq(chi.values, df = 4),
      type = "l",
      xlab = expression(chi ^ 2),
      ylab = ""
    )
    mtext(side = 2, expression(f(chi ^ 2)), line = 2.5)
    lines(x = chi.values, y = dchisq(chi.values, df = 10))
    text(x = 6, y = .15, label = "df=4")
    text(x = 16, y = .07, label = "df=10")
  })
  
  #Linear Regression Model
  
  
  model_lm <- lm(hp ~ mpg, data = mtcars)
  
  model_lm_pred <- reactive({
    mpgInput <- input$sliderMPG
    predict(model_lm, newdata = data.frame(mpg = mpgInput))
  })
  
  output$lmplot <- renderPlot({
    mpgInput <- input$sliderMPG
    plot(
      mtcars$mpg,
      mtcars$hp,
      xlab = "MPG",
      ylab = "Hoursepower",
      type = "p",
      pch = 19,
      family = "mono"
    )
    if (input$showmodel)
    {
      abline(model_lm, col = "#FF0000", lwd = 4, lty = 6)
    }
    
    
    points(
      mpgInput,
      model_lm_pred(),
      col = "#0B07FF",
      pch = "*",
      cex = 4
    )
  })
  output$pred <- renderText({
    model_lm_pred()
  })
  
  #Poisson Regression - dataset shows absences per year with a number of factors highlighted
  Data<-read.csv("Abs.csv")
  Data<-na.omit(Data)
  
  output$sumfile <- renderPrint({
    Data<-read.csv("Abs.csv")
    Data<-na.omit(Data)
    Data <- Data[c(1,2,3,4,7)]
    summary(Data)
  })
  output$smokercount <- renderPrint({
    Data<-read.csv("Abs.csv")
    Data<-na.omit(Data)
    sum(Data[,5])
  })
  output$drinkercount <- renderPrint({
    Data<-read.csv("Abs.csv")
    Data<-na.omit(Data)
    sum(Data[,6])
  })
  
  poisson.model <- glm(Absences ~ Age + Body.mass.index + Social.smoker + Social.drinker, Data, family = poisson(link = "log"))
  
  output$ppred <- renderText({
    newdata <- data.frame(Age = input$Age, Body.mass.index = input$BMI, Social.smoker = as.numeric(input$SocialSmoker), Social.drinker = as.numeric(input$SocialDrinker))
    round(predict(poisson.model, newdata = newdata, type = "response"))
  })
  
  Data<-read.csv("Abs.csv")
  x1<- Data$Age
  x2<-Data$Body.mass.index
  x3<-Data$Social.smoker
  x4<-Data$Social.drinker
  y<-Data$Absences
  df<-na.omit(data.frame(x1,x2,x3,x4,y))
  
  output$RMSE <- renderText({
    RMSE<-0
    for(i in 1000){
      set.seed(2000)
      n<-nrow(df)
      indexes<- sample(n,n*(80/100))
      trainset<- df[indexes,]
      testset<- df[-indexes,]
      fit<- glm(trainset$y~.,data=trainset, family = poisson(link = "log"))
      pred<-predict(fit,testset[1:4])
      actual <- testset$y
      rmse<-sqrt((sum((pred-actual)^2)/nrow(testset)))
      RMSE<-RMSE+rmse
    }
    RMSE/1000
  })
  
  output$accuracy <- renderText({
    set.seed(2000)
    n<-nrow(df)
    indexes<- sample(n,n*(80/100))
    trainset<- df[indexes,]
    testset<- df[-indexes,]
    actual<-testset$y
    fit<- glm(trainset$y~.,data=trainset, family = poisson(link = "log"))
    pred<-predict(fit,testset[1:4])
    predam<-round(pred)
    tab<-table(predam,actual)
    accuracy<-sum(tab[nrow(tab)==col(tab)])/sum(tab)
    accuracy
  })
  
  output$titanicinfo <- renderPrint({
    data1 <- read.csv("train.csv", header = TRUE)
    summary(data1)
  })
  
  output$surviveprob <- renderPrint({
    
    data1 <- read.csv("train.csv", header = TRUE)
    
    x1 <- data1$Age     
    x2 <- data1$Fare 
    x3 <- data1$Pclass 
    y  <- data1$Survived
    dataset = na.omit(data.frame(x1,x2,x3,y))
    fit.model <- glm(y ~., data = dataset, family='binomial') 
    x <- data.frame(25,5.0,'s')
    
    x <- data.frame(x1=input$age,x2=input$fare,x3=input$class)
    p <- predict(fit.model,x)
    p <- ifelse(p>=0.5,1,0)
    
    if(p == 0){
      ans = "This passenger did not survive the sinking"
    } else {
      ans = "This passenger did survive the sinking"
    }
    print(ans)
  })
  
})

