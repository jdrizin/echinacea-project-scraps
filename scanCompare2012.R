# this script will pull the filenames from directories and compare them against the 
# 2011 harvest list. some of the paths are hard-coded and some are not.
# written 16 Mar 2012, first draft by josh, dir.ea from stuart's code 
# (eventually it'll be part of an echinacea project library)
# this needs to be run on a machine with I drive access and the scans in a 
# directory with scans sorted into 1000s eg c:\dir\1000 c:\dir\2000 c:\dir\3000 etc
#T2000 is my current working machine for this.

#paths
# set which batch you'll use. make sure c:\2011_scans_sorted has that numeric directory
batch <- 9000
firstrun <- FALSE #set to TRUE the first time you run the script
output   <- FALSE #set to true if you want to output a CSV. be careful not to overwrite existing files
setwd(paste("C:\\\\2011_scans_sorted\\", batch, sep="")) #change this line to your directory with number folders

# path to harvest list: set na.strings since not every blank was being picked up as NA
harvList <- read.csv("I:\\\\Departments\\Research\\EchinaceaCG2011\\2011.CG1.Harvest.List.reconciled.csv", na.strings="")

#declare the dir.ea() function
dir.ea <- function(path = ".") {
  if(path == ".") path <- getwd()
  dir <- file.info(list.files(path, full.names = FALSE, recursive = TRUE, include.dirs = FALSE))
  dir$fileName <- row.names(dir)
  dir <- dir[ , c("fileName", "size", "isdir", "mode", "mtime", "ctime", "atime")] #dropped exe for compat.
  row.names(dir) <- NULL
  date <- Sys.time()
  ans <- list(dir = dir,
              path = path,
              date = date
              )
  name <- paste(dirname(path), "/", basename(path), "/", "dir-", basename(path), "-", format(date, "%Y-%b-%d"), ".csv", sep = "")
  ans
}

# fix the letnos from the harvest list, as the format is strange: one column has NAs for non-changes
harvList$letnoHarv <- as.character(harvList$letnoHarv) #you need to make these character vectors
harvList$letnoCorrected <- as.character(harvList$letnoCorrected)
harvList$letnoHarv[complete.cases(harvList$letnoCorrected)] <- harvList$letnoCorrected[complete.cases(harvList$letnoCorrected)]
harvList$no <- as.integer(substr(harvList$letnoHarv, 4, 7))

##############################################################
# start here for subsequent runs of the script
# grab the directory information
scans <- dir.ea()
let <- toupper(substr(scans$dir$fileName, 5, 6)) #make things uppercase, since harvList uses uppercase
no  <- substr(scans$dir$fileName, 1, 4)
letno <- paste(let, no, sep= "-") # SCANNED FILENAMES

#put the issues into vectors. make sure to adjust the numbers in the first missingScans line
extraScans   <- setdiff(letno, harvList$letnoHarv) #scanned files with filename errors
missingScans <- setdiff(harvList$letnoHarv[harvList$no < (batch+1000) & harvList$no >= batch], letno) #letnos without scans
missingScans <- na.omit(missingScans) #for some reason, the previous command makes NAs. omit them
missingScansdf <- harvList[harvList$letnoHarv %in% missingScans,] #pull out only missing scans
missingScansdf <- missingScansdf[missingScansdf$gBagCorrected != "NH", ] #remove not-harvested

###############################################################################
#information about errata
# extraScans* objects list filenames where there is no associated letno (but in letno form)
# you merely need to open the relevant images, check the letno, and rename it appropriately
#
# missingScans are dataframes with information about what's missing. this is useful for
# turning into a worksheet to go hunt them down
###############################################################################

if(firstrun == TRUE){
  extraScansFull <- extraScans
  missingScansFull <- missingScansdf
  }
if(firstrun == FALSE){
  extraScansFull <- c(extraScans, extraScansFull)
  missingScansFull <- rbind(missingScansFull, missingScansdf)
  }

cat("the following letnos / filenames are not in the harvest list:", extraScans, "\ncheck the image for the correct letno")

###############################################################################
# run this AFTER you've c(*,*) and rbinded everything together
###############################################################################
if(output == TRUE){
  #cut out columns and write out CSVs for turning into FIXME datasheets
  missingScansFull <- subset(missingScansFull, select=-c(cgheadid,nmmp,emmr,linePaper,garden,S.1,S.1,
                                                       S.2,S.3,S.4,letnoCorrected,Row,Pos,tt,
                                                       gBagHarv,S.5,harvnoteCorrected,S.6,Block,X,
                                                       cgheadid.1,gBagHarv.1,S.5.1,harvnoteHarv.1,
                                                       S.6.1,Block.1))
  missingScansFull <- missingScansFull[order(missingScansFull$no),] #sort the missing by no
  write.csv(missingScansFull, file="..\\missingScansDatasheet.csv") #this writes to the directory above
  write.csv(extraScansFull, file="..\\extraScansDatasheet.csv")     #don't overwrite existing files, k?
}