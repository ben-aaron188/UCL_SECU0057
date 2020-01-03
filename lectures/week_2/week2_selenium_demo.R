### SECU0050/SECU0057

# SELENIUM DEMO

library(RSelenium)

#make a connection
selenium_firefox = rsDriver(browser=c("firefox"))

#start a driver
driver = selenium_firefox$client

#set target url
target_url = 'https://www.fbi.gov/wanted/kidnap'

#navigate the driver (= simulated browser) to the target url
driver$navigate(target_url)


# 1. set wait intervals
list_for_requests = list()

for(i in 1:5){
  parsed_pagesource <- driver$getPageSource()[[1]]
  result <- read_html(parsed_pagesource) %>%
    html_nodes('h3.title') %>%
    html_nodes('a')
  
  list_for_requests[[i]] = result  
  print(paste('Sent request at:', Sys.time(), sep=" "))
  
  Sys.sleep(5) 
}


# 2. simulate scroll
#navigate the driver (= simulated browser) to the target url
driver$navigate(target_url)

#find the html body
page_body = driver$findElement("css", "body")

#send a scroll command (note that this is a page_down request in Javascript)
page_body$sendKeysToElement(list(key = "page_down"))


# 3. simulate multiple scrolls
#navigate the driver (= simulated browser) to the target url
driver$navigate(target_url)

#find the html body
page_body = driver$findElement("css", "body")

#send multiple scroll commands in a loop
for(i in 1:10){
  page_body$sendKeysToElement(list("key"="page_down"))
  
  # allow some time for this to happen (here: 3 seconds)
  Sys.sleep(3) 
}

#now access the page source (important: you need to do this through the driver)
parsed_pagesource <- driver$getPageSource()[[1]]

#now we can scrape from the page after the simulation
full_results <- read_html(parsed_pagesource) %>%
  html_nodes('h3.title') %>%
  html_nodes('a') %>%
  html_attr('href')

length(full_results)

# close the driver and the server
driver$close()

selenium_firefox$server$stop()

### END