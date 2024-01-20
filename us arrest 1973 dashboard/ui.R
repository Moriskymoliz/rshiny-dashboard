library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(ggplot2)
library(ggtext)
library(ggcorrplot)
library(shinycssloaders)
library(maps)

dashboardPage(
  dashboardHeader(title = 'Exploring the 1973 US arrests data with R & shiny Dashboard',
                  titleWidth = 650,
                  # links to my channels
                  tags$li(class='dropdown',tags$a(href="https://github.com/Moriskymoliz/rshiny-dashboard.git",
                                                  icon('github'),'source code',target='_blank'))
  ),
  dashboardSidebar(
    # sidebarmenu
    sidebarMenu(
      id='sidebar',
      # first menu item
      menuItem('Dataset',tabName ='data',icon = icon('database')),
      menuItem(text='Visualization',tabName = 'viz',icon = icon('chart-line')),
      conditionalPanel("input.sidebar=='viz'&& input.t2=='distro'",
                       selectInput(inputId='var1',label =  'select the variable',choices = ch,selected = 'Rape')),
      conditionalPanel("input.sidebar=='viz'&& input.t2=='relation'",
                       selectInput(inputId='var2',label =  'select the x_variable',choices = ch,selected = 'Rape')),
      conditionalPanel("input.sidebar=='viz'&& input.t2=='relation'",
                       selectInput(inputId='var3',label =  'select the y_variable',choices = ch,selected = 'Assault')),
      conditionalPanel("input.sidebar=='viz'&& input.t2=='trends'",
                       selectInput(inputId='var4',label =  'select the y_variable',choices = c1,selected = 'Rape')),
      menuItem(text = 'Choropleth map',tabName = 'map',icon = icon('map'))
    )
  ),
  dashboardBody(
    tabItems(
      # first tab items 
      tabItem(tabName = 'data',
              tabBox(id='t1',width = 10,
                     tabPanel('About',icon = icon('address-card'),
                              fluidRow(
                                column(width=8,tags$image(src='arrest.jpg',width=500,height=300),
                                       tags$br(),
                                       tags$a('photo by campell jensen on unsplash'),align='center'),
                                column(width=4,tags$br(),
                                       tags$p('This data set contains statistics, in arrests per 100,000 residents for 
                                              assault, murder, and rape in each of the 50 US states in 1973.
                                              Also given is the percent of the population living in urban areas.'))
                              )),
                     tabPanel(title='Data',icon = icon('address-card'),dataTableOutput('dataT')),
                     tabPanel(title='structure',icon = icon('address-card'),verbatimTextOutput('structure')),
                     tabPanel(title='summary stats',icon = icon('address-card'),verbatimTextOutput('summary'))
                     ),),
      # second tab item or landing page here
      tabItem(tabName = 'viz',
              tabBox(id='t2',width = 12,
                     tabPanel(title='crime trend by state',value = 'trends',
                              fluidRow(
                                tags$div(align='center',box(tableOutput('top5'),
                                                            title=textOutput('head1'), collapsible = TRUE,status = 'primary')),
                                tags$div(align='center',box(tableOutput('low5'),
                                                            title=textOutput('head2'),collapsible = TRUE,status = 'primary'))
                              ),
                             withSpinner( plotlyOutput('bar'))),
                     tabPanel(title='Distribution',value = 'distro',withSpinner( plotlyOutput('histplot'))),
                     tabPanel(title='correlation matrix',withSpinner(plotlyOutput('cor'))),
                     tabPanel(title='relationship among arrest type & urban population',
                              radioButtons(inputId='fit',label =  'select the smooth methods',choices = c('lm','loess'),selected = 'lm',inline = TRUE),
                              withSpinner(plotlyOutput('scatter')) ,value = 'relation')
                     )),
      tabItem(tabName = 'map',
              box(selectInput(inputId='crimetype',label='select arrest type',
                              choice=c2,selected = 'Rape',width = 250),
                  withSpinner(plotOutput('map_plot')),width = 12))
      
    )
  )
)