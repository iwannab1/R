## vector 
intV = c(1,2,3);intV 
(charV = c(1, "a", 3)) 
doubleV = c(1, 2, 3.5); doubleV 
booleanV = c(T, F, TRUE); booleanV
as.numeric(booleanV)
attr(booleanV, "desc") = "This is boolean Vector" 
attr(booleanV,"desc") 
str(booleanV) 


## List
x = list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9));x
str(x)


## Factor
x = factor(c("a", "b", "b", "a"));x
class(x)
levels(x)
sex_char = c("m", "m", "m")
sex_factor = factor(sex_char, levels=c("m","f"))
table(sex_char)
table(sex_factor)


## Matrix && Array
(mat = matrix(1:6, ncol = 3, nrow = 2))
(arr = array(1:12, c(2, 3, 2)))
length(mat);length(arr)
nrow(mat);nrow(arr)
ncol(mat);ncol(arr)

rownames(mat) = c("A", "B"); colnames(mat) = c("a", "b", "c"); mat
dimnames(arr) = list(c("A", "B"), c("a", "b", "c"), c("one", "two")); arr


## Data Frame
df = data.frame(x=1:3, y=c("a", "b", "c"), stringsAsFactors=FALSE);df
str(df)
class(df)

cbind(df, data.frame(z=3:1))
rbind(df, data.frame(x=10,y="z"))

data.frame(x = 1:3, y = list(1:2, 1:3, 1:4))  ## error
df = data.frame(x = 1:3)
df$y = list(1:2, 1:3, 1:4)
df
(df = data.frame(x = 1:3, y = I(list(1:2, 1:3, 1:4))))


## subset
a = matrix(1:9, nrow = 3); colnames(a) = c("A", "B", "C");a
a[1:2,]
a[c(T, F, T), c("B", "A")]
a[0, -2]

a = outer(1:5, 1:5, FUN = "paste", sep = ",");a
select = matrix(ncol = 2, byrow = TRUE, c(1,1,3,1,2,4));select
a[select]

df = data.frame(x = 1:3, y = 3:1, z = letters[1:3]);df
df[df$x == 2, ]
df[c("x", "z")]
df[,c("x", "z")]
str(df["x"])
str(df[,"x"])


## simplyfying, preserving
a = list(a=1, b=2);a
a[1]
a[[1]]
a["a"]
a[["a"]]

## reassign
x = 1:5;x
x[c(2,4)] = c(9,23);x
x[-1] = 99;x


## OOB
df = data.frame(a = c(1, 10, NA));df
df$a[df$a < 5] = 0;df
df$a
