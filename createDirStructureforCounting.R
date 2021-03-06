# written spring 2012 by jd. happy words list found by kt
# this script pulls data from the final harvest list (ideally it would pull from scan files)
# this will (eventually) generate a folder structure and assign letnos/filenames to that
# don't run the entire script at once, you might clobber important files.

###############################################################################
# run this section first
###############################################################################

#import harvest list, fix letnos (code from scanCompare2012.R)
harvList <- read.csv("I:\\\\Departments\\Research\\EchinaceaCG2011\\2011.CG1.Harvest.List.reconciled.csv", na.strings="")
harvList$letnoHarv <- as.character(harvList$letnoHarv) #you need to make these character vectors
harvList$letnoCorrected <- as.character(harvList$letnoCorrected)
harvList$letnoHarv[complete.cases(harvList$letnoCorrected)] <- harvList$letnoCorrected[complete.cases(harvList$letnoCorrected)]
harvList <- harvList[harvList$gBagCorrected != "NH" , ]

#import the happy word list: we want the lowercase vector
happy <- read.csv("I:\\\\Departments\\Research\\EchinaceaCG2011\\happyWords.csv")

#figure out how many records we have and how many directories we need
length(harvList$letnoHarv) #2892 files, at the top end. 6 in each dir, 482 directories

harvList$let <- substr(harvList$letnoHarv, 1, 2)
harvList$no <- as.integer(substr(harvList$letnoHarv, 4, 7))
harvList$filename <- paste(harvList$no, harvList$let, ".jpg", sep="")#turn letno into nolet.jpg

###############################################################################
#
# 8000 batch - the other batches are mainly copy and pasted and find and replaced
#
###############################################################################
batch    <- 8000 #set the batch
inb1and2 <- harvList$no < (batch+1000) & harvList$no >= batch #pull out all the nums in the batch
h8000 <- harvList[inb1and2, ] #dataframe of only the batch

#we'll add a few dummy directories, just in case. pull out 490 entries
happyList <- sample(happy$lowercase, 230, replace=FALSE) #i'm not sure if this line is correct
happyDirs <- rep(happyList, each=6)

# put together the vectors, keeping lets and nos, so i can actually write out files in batches

h8000 <- h8000[sample(1: dim(h8000)[1]), ] #sample the dataframe. sample(h8000) won't work
happyDirs8000 <- happyDirs[1:230]
randomHarvList8000 <- data.frame(h8000, happyDirs8000)
leftoverHappyDirs <- happyDirs[(length(randomHarvList8000$letnoHarv)+1):length(happyDirs)]

#write out some useful files
write.csv(randomHarvList8000, file="C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.HarvList8000.csv")
write.csv(leftoverHappyDirs, file="C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.LeftoverHappyDirs.csv")

# create directory structure. only run this this first time.
  setwd("C:\\\\cg2011counting\\")
  dirCommands <- paste("mkdir ", "C:\\cg2011counting\\", unique(randomHarvList8000$happyDirs8000), sep="")
  write.table(dirCommands, file="mkdirCommands.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE) 
  #this writes hard paths. find the .bat file and double-click it to run it.

# move files around this uses hard paths, which is ugly, but i think it's the only way

#put together the copy commands with hard paths. use subsets to do batches manually.
#update this for future years. look out for wide lines and make sure you change the right stuff
moveFiles <- paste("copy ", "C:\\2011_scans_sorted\\8000\\", 
      randomHarvList8000$filename[randomHarvList8000$no < 9000 & randomHarvList8000$no >= 8000], " C:\\\\cg2011counting\\",
      randomHarvList8000$happyDirs[randomHarvList8000$no < 9000 & randomHarvList8000$no >= 8000], "\\",
      randomHarvList8000$filename[randomHarvList8000$no < 9000 & randomHarvList8000$no >= 8000] , sep="")
setwd("C:\\\\cg2011counting\\")
write.table(moveFiles, file="moveFiles8000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE) 
#again, find the batch file and double-click to run it. it's slow.

###############################################################################
#
# 4000 batch - hey, i'm a comment!
#
###############################################################################
#read in the old happy words list
happy <- read.csv("C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.LeftoverHappyDirs.csv")
happy <- happy$x[5:length(happy$x)] #tiny was already used, so drop the first 4 
happyDirs <- as.character(happy)

inb1and2 <- harvList$no < 5000 & harvList$no >= 4000
h4000 <- harvList[inb1and2, ]


# put together the vectors, keeping lets and nos, so i can actually write out files in batches

h4000 <- h4000[sample(1: dim(h4000)[1]), ] #sample the dataframe. sample(h8000) won't work
happyDirs4000 <- happyDirs[1:520]
randomHarvList4000 <- data.frame(h4000, happyDirs4000)
leftoverHappyDirs <- happyDirs[(length(randomHarvList4000$letnoHarv)+1):length(happyDirs)]

#write out some useful files
write.csv(randomHarvList4000, file="C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.HarvList4000.csv")
write.csv(leftoverHappyDirs, file="C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.LeftoverHappyDirs-40008000.csv")

# create directory structure. only run this this first time.
setwd("C:\\\\pelican\\")
dirCommands <- paste("mkdir ", "C:\\pelican\\", unique(randomHarvList4000$happyDirs4000), sep="")
write.table(dirCommands, file="mkdirCommands.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE) 
#this writes hard paths. find the .bat file and double-click it to run it.

# move files around this uses hard paths, which is ugly, but i think it's the only way
#put together the copy commands with hard paths. use subsets to do batches manually.
moveFiles <- paste("copy ", "C:\\2011_scans_sorted\\4000\\", 
                   randomHarvList4000$filename[randomHarvList4000$no < 5000 & randomHarvList4000$no >= 4000], " C:\\\\pelican\\",
                   randomHarvList4000$happyDirs[randomHarvList4000$no < 5000 & randomHarvList4000$no >= 4000], "\\",
                   randomHarvList4000$filename[randomHarvList4000$no < 5000 & randomHarvList4000$no >= 4000] , sep="")
write.table(moveFiles, file="moveFiles4000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE) 
#again, find the batch file and double-click to run it. it's slow.
dirSort <- rep(sample(1:87),each=6)[1:520]
forDataSheet <- cbind(as.character(randomHarvList4000$filename), as.character(randomHarvList4000$happyDirs4000),dirSort)
write.csv(forDataSheet,"C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/count2011_work/4000list.csv")

###############################################################################
#
# 6000 batch
#
###############################################################################
#read in the old happy words list
happy <- read.csv("C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.LeftoverHappyDirs-40008000.csv")
happy <- happy$x[3:length(happy$x)] #celebrate was already used, so drop the first 2
happyDirs <- as.character(happy)

inb1and2 <- harvList$no < 7000 & harvList$no >= 6000
h6000 <- harvList[inb1and2, ]

# put together the vectors, keeping lets and nos, so i can actually write out files in batches
h6000 <- h6000[sample(1: dim(h6000)[1]), ] #sample the dataframe. sample(h8000) won't work
happyDirs6000 <- happyDirs[1:211]
randomHarvList6000 <- data.frame(h6000, happyDirs6000)
leftoverHappyDirs <- happyDirs[(length(randomHarvList6000$letnoHarv)+1):length(happyDirs)]

#write out some useful files
write.csv(randomHarvList6000, file="C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.HarvList6000.csv")
write.csv(leftoverHappyDirs, file="C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.LeftoverHappyDirs-400060008000.csv")

# create directory structure. only run this this first time.
setwd("C:\\\\flamingo\\")
dirCommands <- paste("mkdir ", "C:\\flamingo\\", unique(randomHarvList6000$happyDirs6000), sep="")
write.table(dirCommands, file="mkdirCommands.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE) 
#this writes hard paths. find the .bat file and double-click it to run it.

# move files around this uses hard paths, which is ugly, but i think it's the only way
#put together the copy commands with hard paths. use subsets to do batches manually.
moveFiles <- paste("copy ", "C:\\2011_scans_sorted\\6000\\", 
                   randomHarvList6000$filename[randomHarvList6000$no < 7000 & randomHarvList6000$no >= 6000], " C:\\\\flamingo\\",
                   randomHarvList6000$happyDirs[randomHarvList6000$no < 7000 & randomHarvList6000$no >= 6000], "\\",
                   randomHarvList6000$filename[randomHarvList6000$no < 7000 & randomHarvList6000$no >= 6000] , sep="")
write.table(moveFiles, file="moveFiles6000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE) 
#again, find the batch file and double-click to run it. it's slow.
dirSort <- rep(sample(1:36),each=6)[1:211]
forDataSheet <- cbind(as.character(randomHarvList6000$filename), as.character(randomHarvList6000$happyDirs6000),dirSort)
write.csv(forDataSheet,"C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/count2011_work/6000list.csv")

###############################################################################
#
# 1, 2, 3, 5, 7, 9000 batch
#
###############################################################################

#i screwed up the happylist early, dang it. pull out happy words that have never been used...
#read in old data
happy <- read.csv("I:\\\\Departments\\Research\\EchinaceaCG2011\\happyWords.csv")
old4000 <- read.csv("C:\\Documents and Settings\\jdrizin\\My Documents\\Dropbox\\CGData\\165_count\\count2011\\2011.CG1.HarvList4000.csv")
old6000 <- read.csv("C:\\Documents and Settings\\jdrizin\\My Documents\\Dropbox\\CGData\\165_count\\count2011\\2011.CG1.HarvList6000.csv")
old8000 <- read.csv("C:\\Documents and Settings\\jdrizin\\My Documents\\Dropbox\\CGData\\165_count\\count2011\\2011.CG1.HarvList8000.csv")
oldHappyDirs <- c(as.character(old4000$happyDirs4000), as.character(old6000$happyDirs6000), as.character(old8000$happyDirs8000))
#pull out unused happywords
oldHappyDirs <- unique(oldHappyDirs)
happy <- happy[!(happy$lowercase %in% oldHappyDirs),]
happy <- as.character(happy$lowercase)

happy <- happy$x[6:length(happy$x)] #celebrate was already used, so drop the first 2
happyDirs <- as.character(happy)
happy <- happy[-7] #remove the double word

#pull out 322 directories, to encompass the 1931 in hRest
happyList <- sample(happy, 322, replace=FALSE)
happyDirs <- rep(happyList, each=6)
happyDirs <- happyDirs[1:(length(happyDirs)-1)]

#pull out numbers. differs from above scripts, but is functionally similar
inb1and2 <- c(1000:3999, 5000:5999, 7000:7999, 9000:9999)
hRest <- harvList[harvList$no %in% inb1and2,]

# put together the vectors, keeping lets and nos, so i can actually write out files in batches
hRest <- hRest[sample(1: dim(hRest)[1]), ] #sample the dataframe. sample(h8000) won't work
randomHarvListRest <- data.frame(hRest, happyDirs)
leftoverHappyDirs <- happyDirs[(length(randomHarvListRest$letnoHarv)+1):length(happyDirs)]

#write out some useful files
write.csv(randomHarvListRest, file="C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.HarvListRest.csv")
#write.csv(leftoverHappyDirs, file="C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/2011.CG1.LeftoverHappyDirs-400060008000.csv")

# create directory structure. only run this this first time.
setwd("C:\\\\albatross\\")
dirCommands <- paste("mkdir ", "C:\\albatross\\", unique(randomHarvListRest$happyDirs), sep="")
write.table(dirCommands, file="mkdirCommands.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE) 
#this writes hard paths. find the .bat file and double-click it to run it.

# move files around this uses hard paths, which is ugly, but i think it's the only way
#put together the copy commands with hard paths. use subsets to do batches manually.
moveFiles1000 <- paste("copy ", "C:\\2011_scans_sorted\\1000\\",                    randomHarvListRest$filename[randomHarvListRest$no %in% 1000:1999], " C:\\\\albatross\\", randomHarvListRest$happyDirs[randomHarvListRest$no %in% 1000:1999], "\\", randomHarvListRest$filename[randomHarvListRest$no %in% 1000:1999] , sep="")
write.table(moveFiles1000, file="moveFiles1000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE) 

moveFiles2000 <- paste("copy ", "C:\\2011_scans_sorted\\2000\\",                    randomHarvListRest$filename[randomHarvListRest$no %in% 2000:2999], " C:\\\\albatross\\", randomHarvListRest$happyDirs[randomHarvListRest$no %in% 2000:2999], "\\", randomHarvListRest$filename[randomHarvListRest$no %in% 2000:2999] , sep="")
write.table(moveFiles2000, file="moveFiles2000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE)

moveFiles3000 <- paste("copy ", "C:\\2011_scans_sorted\\3000\\",                    randomHarvListRest$filename[randomHarvListRest$no %in% 3000:3999], " C:\\\\albatross\\", randomHarvListRest$happyDirs[randomHarvListRest$no %in% 3000:3999], "\\", randomHarvListRest$filename[randomHarvListRest$no %in% 3000:3999] , sep="")
write.table(moveFiles3000, file="moveFiles3000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE)

moveFiles5000 <- paste("copy ", "C:\\2011_scans_sorted\\5000\\",                    randomHarvListRest$filename[randomHarvListRest$no %in% 5000:5999], " C:\\\\albatross\\", randomHarvListRest$happyDirs[randomHarvListRest$no %in% 5000:5999], "\\", randomHarvListRest$filename[randomHarvListRest$no %in% 5000:5999] , sep="")
write.table(moveFiles5000, file="moveFiles5000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE)

moveFiles7000 <- paste("copy ", "C:\\2011_scans_sorted\\7000\\",                    randomHarvListRest$filename[randomHarvListRest$no %in% 7000:7999], " C:\\\\albatross\\", randomHarvListRest$happyDirs[randomHarvListRest$no %in% 7000:7999], "\\", randomHarvListRest$filename[randomHarvListRest$no %in% 7000:7999] , sep="")
write.table(moveFiles7000, file="moveFiles7000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE)

moveFiles9000 <- paste("copy ", "C:\\2011_scans_sorted\\9000\\",                    randomHarvListRest$filename[randomHarvListRest$no %in% 9000:9999], " C:\\\\albatross\\", randomHarvListRest$happyDirs[randomHarvListRest$no %in% 9000:9999], "\\", randomHarvListRest$filename[randomHarvListRest$no %in% 9000:9999] , sep="")
write.table(moveFiles9000, file="moveFiles9000.bat", sep="", row.names=FALSE, col.names=FALSE, quote=FALSE)

#again, find the batch file and double-click to run it. it's slow.

forDataSheet <- cbind(as.character(randomHarvListRest$filename), as.character(randomHarvListRest$happyDirs))
write.csv(forDataSheet,"C:/Documents and Settings/jdrizin/My Documents/Dropbox/CGData/165_count/count2011/count2011_work/Restlist.csv")

