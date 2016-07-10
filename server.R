library(shiny)
pmt <- function(rate, nper, pv) pv/((1-((1+rate)^(-nper)))/rate)

annCF <- function(rate, nper, pv){
    annVal <- pmt(rate, nper, pv)
    IntComp <- NULL
    PrincComp <- NULL
    
    for (i in 1:nper) {
        if (i==1) PrincBal <- pv
        else PrincBal <- c(PrincBal, PrincBal[i-1]-PrincComp[i-1])
        IntComp <- c(IntComp, PrincBal[i]*rate)
        PrincComp <- c(PrincComp, annVal-IntComp[i])
    }
    cbind(IntComp, PrincComp)
}

title <- "Principal and Interest Payments Over Time"
vertax <- "Principal and Interest Components"
horax <- "Time (Years)"


shinyServer(
    function(input, output){
        output$opv = renderPrint({input$pv})
        output$oiry1 = renderPrint({input$iry1 / 100})
        output$oiry2 = renderPrint({input$iry2 / 100})
        output$ony = renderPrint({input$ny})
        output$tbl <- renderTable({
            APR <- c(input$iry1, input$iry2)
            Annuity <- pmt(APR/100, input$ny, input$pv)
            cbind("Annual Percentage Rate" = APR, 
                  "Monthly Repayment" = Annuity,
                  "Total Repayable" = Annuity*input$ny)
        })
        output$POT <- renderPlot({
            rws <- cbind(annCF(input$iry1/100, input$ny, input$pv), 
                         annCF(input$iry2/100, input$ny, input$pv))
            colnames(rws) <- c("IntComp1", "PrincComp1", 
                               "IntComp2", "PrincComp2")
            
            plot(1:input$ny, c(rep(0, input$ny-1),max(rws)), main = title, 
                 xlab = horax, ylab = vertax, type = "n")
            points(rws[,1], type = "o", lwd = 2, col = 4)
            points(rws[,2], type = "o", lwd = 2, col = 4, lty = 3)
            points(rws[,3], type = "o", lwd = 2, col = 2)
            points(rws[,4], type = "o", lwd = 2, col = 2, lty = 3)
            legend("bottomright", legend = c("First Interest Rate / Year", 
                                        "Second Interest Rate / Year"), 
                   col = c(4, 2), pch = 19, bty = "n")
            text(x = 1, y = c(max(rws[1,c(1, 3)]), min(rws[1,c(2, 4)])), 
                 labels = c("Interest Component", "Principal Component"),
                 pos = 4, offset = 1)
        })
    }
)