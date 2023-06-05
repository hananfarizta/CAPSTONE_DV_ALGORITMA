library(shiny)

header <- dashboardHeader(title = "Coffee Dashboard")

sidebar  <- dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Overview", 
               tabName = "Int", 
               icon = icon("seedling")),
      menuItem(text = "Coffee Character", 
               tabName = "cof", 
               icon = icon("coffee"),
               badgeLabel = "country",
               badgeColor = "green"),
      menuItem(text = "Beans Data", 
               tabName = "beans", 
               icon = icon("th")),
    
    selectInput("v_country", "Country", choices = coffee_ratings %>% 
                  select(country_of_origin) %>% 
                  distinct() %>% 
                  arrange(country_of_origin) %>% 
                  drop_na())
    )
)

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "Int",
      h2("Coffee Beans Trading Ratings", align = "center"), 
      fluidRow(valueBox(nrow(cof_clean), 
                        "Data Source", 
                        icon = icon("archive"), 
                        color = "navy"),
               valueBox(round(mean(cof_clean$number_of_bags),2), 
                        "Mean Bags Traded", 
                        icon = icon("cart-plus"),
                        color = "navy")),
      h2 ("This visualization was made to acknowledge the coffee beans character that have been traded from several country in the world")
      ),
    
    tabItem(
      tabName = "cof",
      
      
      fluidRow(box(plotlyOutput(outputId = "coffee_flavour")),
               box(plotlyOutput(outputId = "coffee_variety"))),
      
      fluidRow(box(plotlyOutput(outputId = "coffee_dif")),
               box(dataTableOutput(outputId = "coffee_table")))
          ),
               
    tabItem(
      tabName = "beans",
        dataTableOutput(outputId = "cof_rate"))
 )
)

      

dashboardPage(
  skin = "red",
  header = header,
  body = body,
  sidebar = sidebar
)
