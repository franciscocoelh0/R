
server <- function(input, output, session) {
 
# Reactive functions ------------- 
  observe({
    if(input$selectall > 0) {
     if (input$selectall %% 2 == 0)
    {
      updateCheckboxGroupInput(session,inputId = "framework",
                               label = "Seleccionar período",
                               choices = c("Word Cloud" = "año", "TF_IDF" = "año_mes","Framework3" = "mes",
                                           "Framework4" = "día_semana", "Framework5" = "Hora"),
                               selected = c("año", "año_mes", "mes", "día_semana", "Hora"))
    }
    else
    {
      updateCheckboxGroupInput(session,inputId = "framework",
                               label = "Seleccionar período",
                               choices = c("Word Cloud" = "año", "TF_IDF" = "año_mes","Framework3" = "mes",
                                           "Framework4" = "día_semana", "Framework5" = "Hora"))
    }
    }
      })
  
  table_freq1 <- reactive({ #I can't make the top_n work
    b <- input$topfreq
    
    all_df1 <- all_df%>% 
      ungroup() %>%  
      mutate(word = reorder(word, n))
      
    all_df2 <- all_df1[1:b,] %>%
      mutate(word = reorder(word, n)) %>%
      ggplot(aes(word, n, fill = n)) +  
      geom_bar(stat = "identity") +  ylab("Contribution to sentiment") +  
      coord_flip()
    
    return(all_df2)
  })
  
  data_up <- reactive({
    inFile <- input$file1
    if (is.null(inFile)) #This removes the error shown when there is no file uploaded
      return(NULL)
    
    df_up <- read_document(file = inFile$datapath)
    table_up <- create_df(input$people_s,input$question_s,df_up)
    return(table_up)
  })
  
  bigram_up <- reactive({
    inFile <- input$file1
    if (is.null(inFile)) #This removes the error shown when there is no file uploaded
      return(NULL)
    
    df_up <- read_document(file = inFile$datapath)
    big_up <- bigram_network(input$people_s,input$question_s,df_up)
    return(big_up)
  })
  
  senti_table <- reactive({
    inFile2 <- input$file1
    if (is.null(inFile2)) #This removes the error shown when there is no file uploaded
      return(NULL)
    
    data_up() %>%
      token_function(q_col = 1)
  })
  
  sent_library <- reactive({
    paste(input$sentiments)
  })
  
  bi_reac_gram <- reactive({
    
  })
  
# Frequency (tokens) -----------
  
  output$freq_table <- renderPlot(
    table_freq1()
  )
  
# Word Clouds ------------  
  
  output$word_cloud1 <- renderPlot({
    frequencies_tokens_nostop_1 %>%
    inner_join(get_sentiments(sent_library())) %>%
    dplyr::count(word, sentiment, sort=TRUE) %>%
    acast(word ~sentiment, value.var="n", fill=0) %>%
    comparison.cloud(colors = c("red","green", "orange","purple","pink"),
                       max.words=300,
                       scale=c(2.0,2.0),
                       title.size = 2)
  })
  
  output$word_cloud2 <- renderPlot({
    frequencies_tokens_nostop_2 %>%
      inner_join(get_sentiments(sent_library())) %>%
      dplyr::count(word, sentiment, sort=TRUE) %>%
      acast(word ~sentiment, value.var="n", fill=0) %>%
      comparison.cloud(colors = c("red","green", "orange","purple","pink"),
                       max.words=300,
                       scale=c(2.0,2.0),
                       title.size = 2)
  })
  
  output$word_cloud3 <- renderPlot({
    frequencies_tokens_nostop_3 %>%
      inner_join(get_sentiments(sent_library())) %>%
      dplyr::count(word, sentiment, sort=TRUE) %>%
      acast(word ~sentiment, value.var="n", fill=0) %>%
      comparison.cloud(colors = c("red","green", "orange","purple","pink"),
                       max.words=300,
                       scale=c(2.0,2.0),
                       title.size = 2)
  })
  
  output$word_cloud4 <- renderPlot({
    frequencies_tokens_nostop_4 %>%
      inner_join(get_sentiments(sent_library())) %>%
      dplyr::count(word, sentiment, sort=TRUE) %>%
      acast(word ~sentiment, value.var="n", fill=0) %>%
      comparison.cloud(colors = c("red","green", "orange","purple","pink"),
                       max.words=300,
                       scale=c(2.0,2.0),
                       title.size = 2)
  })
  
  output$word_cloud5 <- renderPlot({
    frequencies_tokens_nostop_5 %>%
      inner_join(get_sentiments(sent_library())) %>%
      dplyr::count(word, sentiment, sort=TRUE) %>%
      acast(word ~sentiment, value.var="n", fill=0) %>%
      comparison.cloud(colors = c("red","green", "orange","purple","pink"),
                       max.words=300,
                       scale=c(2.0,2.0),
                       title.size = 2)
  })

# tf_idf -------------
  
  output$homeof_tfidf <- renderPlot({
    all_df %>%
      filter(n >= 2) %>%
      bind_tf_idf(word, question,n)%>%
      arrange(desc(tf_idf)) %>%
      mutate(word=factor(word, levels=rev(unique(word)))) %>%
      group_by(question) %>%
      top_n(15) %>%
      ungroup %>%
      ggplot(aes(word, tf_idf, fill=question))+ 
      geom_col(show.legend=FALSE)+
      labs(x=NULL, y="tf-idf")+
      facet_wrap(~question, ncol=2, scales="free")+
      coord_flip()
  })
  
# Bi-gram -----------------
  
  output$n_ngram_net <- renderPlot({
    my_bigrams
  })
  
# LDA -------

  output$lda <- renderPlot({
    top_terms_my_dtm
  })
  
# Prediction ---------
  
  output$prediction_mod <- renderPrint({
    summary(NB_classifier)
  })
  
# UI - Word Cloud ---------------
  
  output$moreControls <- renderUI({
    div(
      style = "position: relative; backgroundColor: #ecf0f5",
      tabBox(
        id = "word_cloud",
        width = NULL,
        height = 450, #Determine the height for the UI
        tabPanel(
          title = "Word Cloud - Q1",
          div(
            style = "position: absolute; left: 0.5em; bottom: 0.5em;"
          ),
          withSpinner(
            plotOutput("word_cloud1", height = 450),
            type = 4,
            color = "#d33724", 
            size = 0.7 
          )
        ),
        tabPanel(
          title = "Word Cloud - Q2",
          div(
            style = "position: absolute; left: 0.5em; bottom: 0.5em;"
          ),
          withSpinner(
            plotOutput("word_cloud2", height = 450),
            type = 4,
            color = "#d33724", 
            size = 0.7 
          )
        ),
        tabPanel(
          title = "Word Cloud - Q3",
          div(
            style = "position: absolute; left: 0.5em; bottom: 0.5em;"
          ),
          withSpinner(
            plotOutput("word_cloud3", height = 450),
            type = 4,
            color = "#d33724", 
            size = 0.7 
          )
        ),
        tabPanel(
          title = "Word Cloud - Q4",
          div(
            style = "position: absolute; left: 0.5em; bottom: 0.5em;"
          ),
          withSpinner(
            plotOutput("word_cloud4", height = 450),
            type = 4,
            color = "#d33724", 
            size = 0.7 
          )
        ),
        tabPanel(
          title = "Word Cloud - Q5",
          div(
            style = "position: absolute; left: 0.5em; bottom: 0.5em;"
          ),
          withSpinner(
            plotOutput("word_cloud5", height = 450),
            type = 4,
            color = "#d33724", 
            size = 0.7 
          )
        )
      )
    )
  })
  
  
# Uploaded data ---------
  
  output$upload_file <- renderTable({
    head(data_up())
  })
  
  output$up_sentiment <- renderTable({
    senti_table()
  })
  
  output$bigram_netup <- renderPlot({
    bigram_up()
  })
  
  output$lda_custom <- renderPlot({
    lda_up()
  })
}