library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)

source("auth_public.r", encoding="UTF-8")
source("uvoz/uvoz.r", encoding="UTF-8")

shinyServer(
  server <- function(input, output){
    
    # Vzpostavimo povezavo
    conn <- src_postgres(dbname = db, host = host,
                         user = user, password = password)
    
    
    
    output$ime1 <- renderText({c(paste0("Ime ekipe: ", input$ekipa1))})
    output$mesto1 <- renderText({paste0("Mesto: ",as.character(tabelaEkipa %>% filter(Ekipa %in% input$ekipa1)%>% select(Mesto)))})
    output$stadion1 <- renderText({paste0("Stadion in kapaciteta: ", as.character(tabelaEkipa %>% filter(Ekipa %in% input$ekipa1)%>% select(Stadion)),", ",as.character(tabelaEkipa %>% filter(Ekipa %in% input$ekipa1)%>% select(Kapaciteta)) )})
    output$manager1 <- renderText({paste0("Manager: ",as.character(tabelaVodstvo %>% filter(ekipa %in% input$ekipa1)%>% select(manager)))})
    
    output$ime2 <- renderText({c(paste0("Ime ekipe: ", input$ekipa2))})
    output$mesto2 <- renderText({paste0("Mesto: ",as.character(tabelaEkipa %>% filter(Ekipa %in% input$ekipa2)%>% select(Mesto)))})
    output$stadion2 <- renderText({paste0("Stadion in kapaciteta: ", as.character(tabelaEkipa %>% filter(Ekipa %in% input$ekipa2)%>% select(Stadion)),", ",as.character(tabelaEkipa %>% filter(Ekipa %in% input$ekipa2)%>% select(Kapaciteta)) )})
    output$manager2 <- renderText({paste0("Manager: ",as.character(tabelaVodstvo %>% filter(ekipa %in% input$ekipa2)%>% select(manager)))})
    
    output$tabela1 <- renderDataTable({tabelaIgralcev %>% filter(Ekipa %in% input$ekipa1, Pozicija %in% input$pozicija) %>% select(Igralec,Pozicija,Nastopi,Podaje,Goli)},
                                      options = list(searching = FALSE, paging = FALSE))
    output$tabela2 <- renderDataTable({tabelaIgralcev %>% filter(Ekipa %in% input$ekipa2, Pozicija %in% input$pozicija) %>% select(Igralec,Pozicija,Nastopi,Podaje,Goli)},
                                      options = list(searching = FALSE, paging = FALSE))
    output$tekma1 <- renderDataTable({tabelaTekma %>% filter(DEkipa %in% input$ekipa2,as.Date(Datum,"%d.%m.%Y") > input$zacetek, as.Date(Datum,"%d.%m.%Y") < input$konec) %>% select(Datum,"Domači"=DEkipa,"Gostje"=GEkipa,"Goli domačih"=DGol,"Goli gostov"=GGol)},
                                     options = list(searching = FALSE, paging = FALSE))
    output$tekma2 <- renderDataTable({tabelaTekma %>% filter(DEkipa %in% input$ekipa2,as.Date(Datum,"%d.%m.%Y") > input$zacetek, as.Date(Datum,"%d.%m.%Y") < input$konec) %>% select(Datum,"Domači"=DEkipa,"Gostje"=GEkipa,"Goli domačih"=DGol,"Goli gostov"=GGol)},options = list(searching = FALSE, paging = FALSE))
    
    
  })