#' ### cloud project

#' Scratch Notes

#' project choices
#'
#' - graph mining, network analysis with commoncrawl data https://commoncrawl.org/the-data/get-started/might need to use amazon EMR to retreive, R has wrappers for warc files, or use sparkwarc to interact with warc files https://rdrr.io/cran/sparkwarc/f/README.md or access the data by cli https://commoncrawl.org/access-the-data/
#' - weather data, tornadoes etc https://aws.amazon.com/marketplace/pp/prodview-yyq26ae3m6csk?sr=0-13&ref_=beagle&applicationId=AWSMPContessa#resources
#' - POWER project, renewable energy https://aws.amazon.com/marketplace/pp/prodview-oj7al3ipm7e4y?sr=0-116&ref_=beagle&applicationId=AWSMPContessa#resources

#' sample problem statements

#' - social network analysis: explore network between 'hiring' and 'open to work' in LinkedIn
#' - social network analysis: explore connection between network density and job status on LinkedIn
#' - social network analysis: investigate connectivity trends of certain attributes over time

#' Tech Stack Choices:
#'
#' - coding in R, bash
#' - in-memory computing in spark
#' - storage in s3
#' - computing instances in ec2



#' network analysis ---------------------------------------------------------------
#' important metrics:
#' 1. ______ features
#' network density; how connected is a network
#' average path length; how efficiently a network is connected
#' transitivity; chances of influenced connectivity, idea of potentially underlying mechanisms in network, clustering
#' degree distribution; gives idea of distribution of connectivity in a network
#' 2. positional features




#' spark --------------------------------------------------------------------------
#' Can be used with R
#' has powerful feature transformers

#' I installed spark to my local machine to experiment before experimenting on the cloud
#'
#'
library(sparklyr)
spark_available_versions()

# `spark_install(version = "3.2.0")` the file was 287MB

# check the version of spark running

 spark_installed_versions()

# connect to spark with personal settings

conf <-  spark_config()
conf$`sparklyr.cores.local` <- 6
conf$`sparklyr.shell.driver-memory` <- 8
conf$`spark.memory.fraction` <- 0.9

sc <- spark_connect(master = "local", version = "3.2.0", config = conf)
#facing connection issues, to trouble shoot

#we can get additional info on our spark instance on the following URL http://localhost:4040/storage/, the 'executors' page has most of the configurations we set above
# add test dataset to see if it will still be there when we disconnect and reconnect, the dataset disappeared, in-memory computing.
flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
airlines_tbl <- copy_to(sc, nycflights13::flights, "airlines")

#'test wrangling
#'
select(flights_tbl, year:day, arr_delay, dep_delay)

c <- flights_tbl %>%
  filter(month == 5, day == 17, carrier %in% c('UA', 'WN', 'AA', 'DL')) %>%
  select(carrier, dep_delay, air_time, distance) %>%
  mutate(air_time_hours = air_time / 60) %>%
  arrange(carrier)

#' data wont actually be loaded to R until we call upon the variable, but can be interacted with.

c

#' to load the data into R's memory for further analysis we use collect,
carrierhours <- collect(c)

#' can be used to connect with AWS S3 buckets,


#library(sparklyr)
#conf <- spark_config()
#conf$sparklyr.defaultPackages <- "org.apache.hadoop:hadoop-aws:3.3.3"
#sc <- spark_connect(maste = "local", config = conf)

#' to learn more...

#' what are sparkjobs?

  #' aws s3-----------------------------------------------------------------------------------
#' - need amazon account
#' - is durable
#' - can intergrate with aws lambda for automation
#' - need to download aws-cli,to use aws s3api
#' - need to pick the correct storage class
#' - enable versioning, might be useful

#' spark ml pipelines----------------------------------------------------------------------

#' h2o--------------------------------------------------------------------------------------
#'
#' can interact with r
#' h2o objects can be changed to and from spark objects


#' aws data exchange------------------------------------------------------------------------

#' aws ec2----------------------------------------------------------------------------------

#' aws glue----------------------------------------------------------------------------------


#' aws sagemaker----------------------------------------------------------------------------


#' aws athena------------------------------------------------------------------------------
#'  we can use sql with athena to load the data into s3
#'  very slow
#'  https://skeptric.com/common-crawl-index-athena/
#'  Whenever you run a query in Athena the output is stored as an uncompressed CSV in S3 in the staging bucket you configured
#'  https://dyfanjones.github.io/RAthena/ to connect with athena tables and query from r

#' aws cli-----------------------------------------------------------------------------------
#' https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3.html
