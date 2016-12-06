library(dplyr)
library(tidyr)
require(stringr)

setwd("~/kca/data")

dong_code = read.csv("dong_code.csv", stringsAsFactors = F)
maxcnt = max(dong_code$X)
dong_code = rbind(dong_code, c(maxcnt+1, "경기도 여주군", "4167"), 
                  c(maxcnt+2, "충청남도 연기군", "3611"), c(maxcnt+3, "충청북도 청원군", "4311"))

findCode = function(x){
  ret = dong_code %>% filter(dong == x) %>% select(code)
  ret[1,1]
}


df = read.csv("월간_매매가격지수_종합.csv", skip=18, header=F, stringsAsFactors = F)

prevName = ""
makeSidoName = function(x){
  if(x == "서울")
     x = paste0(x,"특별시")
  else if(x == "인천" || x == "부산" || x == "대구" || x == "광주" || x == "대전" || x == "울산")
    x = paste0(x,"광역시")
  else if(x == "세종")
    x = paste0(x,"특별자치시")
  else if(x == "경기")
    x = "경기도"
  else if(x == "강원")
    x = "강원도"
  else if(x == "충북")
    x = "충청북도"
  else if(x == "충남")
    x = "충청남도"
  else if(x == "전북")
    x = "전라북도"
  else if(x == "전남")
    x = "전라남도"
  else if(x == "경북")
    x = "경상북도"
  else if(x == "경남")
    x = "경상남도"
  else if(x == "제주")
    x = "제주특별자치도"
  
  if(x != "")
    prevName <<- x
  
  prevName
}


df$SIDO = sapply(df$V1, makeSidoName)

df2 = df %>% select(SIDO, V2:V64) %>% mutate(GUGUN=paste0(V2,V3,V4)) 

sidogugun = df2 %>% select(SIDO, GUGUN)
cnt = nrow(df2)
df_2009 = cbind(sidogugun,rep(2009,cnt),df2[,5:16])
df_2010 = cbind(sidogugun,rep(2010,cnt),df2[,17:28])
df_2011 = cbind(sidogugun,rep(2011,cnt),df2[,29:40])
df_2012 = cbind(sidogugun,rep(2012,cnt),df2[,41:52])
df_2013 = cbind(sidogugun,rep(2013,cnt),df2[,53:64])

col_name = c("SIDO","GUGUN","YEAR", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
colnames(df_2009) = col_name;colnames(df_2010) = col_name;colnames(df_2011) = col_name;colnames(df_2012) = col_name;colnames(df_2013) = col_name

redf = rbind(df_2009, df_2010, df_2011, df_2012, df_2013)
convertNumber = function(x) as.numeric(x)

redf = cbind(redf[1:3], apply(redf[4:15],2,convertNumber)) %>% mutate(TOTAL=rowSums(.[4:15])) %>% select(SIDO, GUGUN, YEAR, TOTAL)

redf = redf %>% mutate("dong_full"=paste(SIDO, GUGUN, sep=" "))
redf$GUGUN_CODE = sapply(redf$dong_full, findCode)
redf = redf %>% select(-dong_full)

write.csv(redf, "homesalesindex.csv", fileEncoding = "UTF8")
s