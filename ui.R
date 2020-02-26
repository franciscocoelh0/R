
ui <- dashboardPage(
  skin = "blue",
  title = "Team 11", #Where can we see this?
  
  dashboardHeader(
    title =  "Team 11",
    titleWidth = 300,
    dropdownMenu(
      type = "messages",
      messageItem(
        from = "LuisPe",
        message = "We need to think more",
        href = "https://pics.conservativememes.com/thinking-face-meme-generator-imgflip-54271778.png"),
      
      # Add a second messageItem() 
      messageItem(
        from = "DataRat",
        message = "We are lucky",
        href = "https://pics.me.me/%D0%BE%D0%BD-god-im-solucky-memegenerator-net-oh-god-im-so-lucky-50042125.png")
    )
  ), 
  
  dashboardSidebar(
    sidebarMenu(
      
      #Select the frameworks you want to apply to the data
      menuItem(text = "Filters",
               icon = icon("filter"),
               tabName = "tab1",
               numericInput(inputId = "topfreq",
                            label = "Amount of values to show on frequency",
                            value = 5, min = 3, max = 50),
               selectInput(inputId = "sentiments",
                                  label = "Select sentiment library",
                                  choices = c("NRC" = "nrc", "Bing" = "bing")),
               br()
               # actionButton("selectall",
                            # label = "Select All")
               ),

      #This menuItex is used to allow the user to upload their data and analyze it using our class framework
      menuItem(text = "Upload your data",
               icon = icon("file-upload"),
               tabName = "tab2",
               numericInput("people_s", "How many entries does your file has?",
                            value = 10, min = 10, max = 100),
               numericInput("question_s", "How many questions does your file has?",
                            value = 3, min = 3, max = 50),
               fileInput("file1", "Choose text File",
                         accept=c("text/csv",
                                  "text/comma-separated-values,text/plain"),
                         placeholder = "Select file")
               ),
      
    menuItem(text = "Frameworks",
             icon = icon("toolbox"),
             tabName = "tab3",
             checkboxGroupInput(inputId = "framework",
                                label = "Insert Period",
                                choices = c("Word Cloud" = "año", "TF_IDF" = "año_mes","Framework3" = "mes",
                                            "Framework4" = "día_semana", "Framework5" = "Hora"),
                                selected = "año"),
             actionButton("selectall",
                          label = "Select All")
             )
    )
  ), 
  
  dashboardBody(fluidPage(
    
    # Clas -----
    
    h1("DO HULT STUDENTS PREFER  WORKING FROM  HOME  MORE THAN GOING TO OFFICE ?"),
    h6("Q1:  How do you like to spent your time?"),
    h6("Q2:  Do you like to socialize?"),
    h6("Q3:  Do you have kids ?"),
    h6("Q4:  How do you like to commute ?"),
    h6("Q5:  What kind of clothes you wear at work ?"),
    
    img(src = "trends.png", height = 500, width = 800),
    h1("Frequency table"),
    plotOutput("freq_table"),
    
    h1("Sentiment - Word clouds"),
    #plotOutput("word_cloud1"),
    uiOutput("moreControls"),
    br(),
    h3("Business Insight"),
    p("Wordcloud Question 2
    •	Pretty neutral
    •	Strong words such as 
o	Communication
o	Overwhelming
o	Love
o	Passion
•	5 sentiment
o	Joy
o	Anticipation
o	Trust
o	Positive
o	Negative
•	Would be interesting to compare to sentiment frequency count!

Wordcloud Question 3
•	Neutral
•	Strong words such as
o	Brother
o	Love 
•	4 sentiments
o	Joy
o	Anticipation
o	Negative
o	Trust
•	Would be interesting comparing to sentiment frequency count!

Wordcloud Question 4
•	Words leaning more towards  positive, with words such as
o	Professional
o	Counselor
o	Prefer
•	6 sentiments
o	Trust
o	Positive
o	Negative
o	Fear
o	Anticipation
o	Anger
•	Would be interesting comparing to sentiment frequency count!"), #this is for the ideas to be expressed
    br(),
    br(),
    
    h1("TF_IDF table"),
    plotOutput("homeof_tfidf"),
    h3("Business Insight"),
    p("For question 1 How do you like to spend your time?
most people that we ask like to spend their time on home and nature. When they like watching TV or netflix when they are at home. Following by reading, cooking and studying.
For question 2, Do you like to socialize?
Lots of people like socializing by playing games, making joy and sharing food.
For question 3,Do you have kids ?
Most people said they will have kids in the future and would like to have a girl.
For question 4, How do you like to commute?
Most people would like to walk to commute. Following by public transportation such as bus and trains, then by car, scooter and bike. 
For question 5, What kind of clothes do you wear at work ?
Most people like to wear casually to work such as wearing jeans. Following by wearing formal clothes such as a suit and blazer."),
    br(),
    br(),
    
    h1("Bi-gram network"),
    plotOutput("n_ngram_net",
               height = "600px"),
    h3("Business Insight"),
    p("Bi-grams are two consecutive words tokenized. 
In order to better understand these words relationship, simultaneously, we developed a bi-gram network. 
“Wear”, “time”, “watching” were some of the most popular nodes preceding or succeeding  a huge variety of words. 
For instance, “time” was correlated to words such as “playing” which was indirectly linked to watching, through other words creating the bigram we see on the bottom. This shows that people have very broad ways of spending their time. 
On top of that, wear was linked to multiple words such as “sport”, “form”, “casual”, probably indicating that people have very different dressing styles."),
    br(),
    br(),
    
    h1("LDA"),
    plotOutput("lda"),
    h3("Business Insight"),
    p("We divided our data into two main topics.
As we can see from the graphs in the first one people talk more about the clothing, its types, so we named it “Dressing”.
For the second one the commute options are mainly mentioned. We gave a name “Commute”.
The graph shows that out of our 6 questions these are the ones containing more insights and information."),
    
    h1("Predictive model"),
    verbatimTextOutput("prediction_mod"),
    
    
    # Extra -------
    
    h1("Uploaded Data"),
    h3("Head of loaded data"),
    tableOutput("upload_file"),
    h3("Net sentiment"),
    tableOutput("up_sentiment"),
    h3("Bigram network"),
    plotOutput("bigram_netup")
    
  )
  )
)
