# load twitter library - the rtweet library is recommended now over twitteR
library(rtweet)
# plotting and pipes - tidyverse!
# library(ggplot2)
# library(dplyr)
# library(stringr)
# text mining library
# library(tidytext)

consumer_key = "idNYoqv2yp3MPjokt87sG7CLs"
consumer_secret = "InNGLHlMJ8kLmu3wRCJyHAIfuY3iEzzdP2b9JAvoMHqviF30pw"
access_key = "1386001563508822016-noWXKHEYkjNP3xGs0TYkvQEhFKEWry"
access_secret = "XhwZfCvruXU6d8hWZn45HDAG0Adzqhvh1tWZKfeiyldYs"

# create token named "twitter_token"
twitter_token <- create_token(
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token = access_key,
  access_secret = access_secret)

start_time <- Sys.time()
tesla <- search_tweets(q='tesla -nikola', n = 500, lang = 'en', 
                       type =  "recent" ,include_rts = FALSE , retryonratelimit = FALSE)
end_time <- Sys.time()
end_time - start_time
# 4.10909  secs

tesla_df<-tesla[,c(1,2,3,4,5,6,13,14,72,73,74,84,85)]
tesla_df<-tesla_df[,c(5,2,3,6,7,8,11,9,1,4,10,13,12)]
colnames(tesla_df)<- c("Tweets","ID","Date","Source",
                       "Favourites","RTs","Location",
                       "Tweet_URL","UID","Username",
                       "DisplayName","ProfileLink","Verified")

# Checks which variable has Non Basic Latin Characters
# https://en.wikipedia.org/wiki/List_of_Unicode_characters#:~:text=at%20a%20terminal.-,Latin%20script%5Bedit%5D,-Main%20article%3A

# colMeans(data.frame(c(with(tesla_df, grepl("[^ -~]", Tweets))),c(with(tesla_df, grepl("[^ -~]", ID))),c(with(tesla_df, grepl("[^ -~]", Date))),c(with(tesla_df, grepl("[^ -~]", Source))),c(with(tesla_df, grepl("[^ -~]", Favourites))),c(with(tesla_df, grepl("[^ -~]", RTs))),c(with(tesla_df, grepl("[^ -~]", Location))),c(with(tesla_df, grepl("[^ -~]", Tweet_URL))),c(with(tesla_df, grepl("[^ -~]", UID))),c(with(tesla_df, grepl("[^ -~]", Username))),c(with(tesla_df, grepl("[^ -~]", DisplayName))),c(with(tesla_df, grepl("[^ -~]", ProfileLink))),c(with(tesla_df, grepl("[^ -~]", Verified)))))
# Result:
  # Tweets, Source, Location, DisplayName


# subset(tesla_df, grepl("[^ -~]",Tweets))
# str_replace_all(apply(tesla_df,2,as.character),"[^ -~]"," ")
index1<-with(tesla_df, grepl("[^ -~]", Tweets))
index2<-with(tesla_df, grepl("[^ -~]", Source))
index3<-with(tesla_df, grepl("[^ -~]", Location))
index4<-with(tesla_df, grepl("[^ -~]", DisplayName))
# tesla_df[index1,"Tweets"]<-gsub("[^ -~]"," ",tesla_df[index1,"Tweets"])

for (row in 1:nrow(tesla_df)){
  if(index1[row] || index2[row] ||index3[row] ||index4[row]){
    tesla_df[row,"Tweets"]<-gsub("[^ -~]"," ",tesla_df[row,"Tweets"])
    tesla_df[row,"Source"]<-gsub("[^ -~]"," ",tesla_df[row,"Source"])
    tesla_df[row,"Location"]<-gsub("[^ -~]"," ",tesla_df[row,"Location"])
    tesla_df[row,"DisplayName"]<-gsub("[^ -~]"," ",tesla_df[row,"DisplayName"])
  }
}

#Convert Dataframe into CSV file
write.csv(apply(tesla_df,2,as.character),file="tesla_listNormal.csv",)
# write.csv(apply(tesla,2,as.character),file="tesla_listNormal.csv",)
