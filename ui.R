library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Loan Amortization: Sensitivity Analysis"),
    sidebarPanel(
        h3('Model Parameters'),
        numericInput('pv', 'Present Value (in $):', value = 300000, min = 0, step = 1000),
        numericInput('iry1', 'First Interest Rate / Year (in %):', 7, min = 0, max = 50, step = .1),
        numericInput('iry2', 'Second Interest Rate / Year (in %):', 8, min = 0, max = 50, step = .1),
        numericInput('ny', 'Number of Years', 30, min = 1)
    ),
    mainPanel(
        h3('Compare Results for Two Interest Rates'),
        tableOutput('tbl'),
        h5('Monthly Repayment = Interest Component + Principal Component'),
        plotOutput('POT')
    )
))