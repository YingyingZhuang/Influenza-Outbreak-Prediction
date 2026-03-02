library(R.matlab)
library(data.table)
#read mat file
mat_data<-readMat("Users/zhuangyingying/Desktop/info6105/finalproject/yingyingzhuang_final_project/influenza_outbreak_dataset.mat")
# View file headers
attr(mat_data, "header")
#check data names
print(names(mat_data))
# View variable structure
# str(mat_data)
# See the structure of each variable.Show only first-class structures
str(mat_data, max.level = 1)  
#understand data structure 
# View the features of flu.X.tr
mat_data$flu.X.tr[[1]]
# View the features of flu.Y.tr
mat_data$flu.Y.tr[[1]]
#View the features of flu.locs
mat_data$flu.locs[[1]]
# See top 5 keywords
head(unlist(mat_data$flu.keywords), 10)

str(mat_data$flu.X.tr)
str(mat_data$flu.Y.tr)
str(mat_data$flu.X.te)
str(mat_data$flu.Y.te)
str(mat_data$flu.locs)
str(mat_data$flu.keywords)
