## SE370 AY22-2
## Lesson 12 - Control Structures II


## Last class, we talked a lot about loops and conditionals. 
# Today, we are going to focus on nesting control structures 
# and writing functions.

## FUNCTIONS

# A function is a set of statements organized together to 
# perform a specific task. R has many built-in functions, and
# also allows users to create their own functions.

# Let's write a simply function, "my_fun," that takes a numeric
# input and returns that input + 10.

my_fun <- function(input){
  return(input + 10)
}

my_fun(2)


# Functions can also take multiple inputs. Let's update "my_fun"
# so it adds two numbers together. Then, add 279 and 45 together.

my_fun <- function(input_1, input_2){
  return(input_1 + input_2)
}

my_fun(279, 45)


# Functions can include optional inputs. These are inputs where
# we set a default value. Let's update "my_fun" one more time...
# now, we want it to add anywhere from 2 to 5 numbers together. We 
# should require 2 inputs, but set the default value for the 3rd,
# 4th, and 5th inputs to 0.

my_fun <- function(input_1, input_2, input_3 = 0, input_4 = 0, 
                   input_5 = 0){
  return(sum(input_1, input_2, input_3, input_4, input_5))
}

# Let's add the numbers 33 + 47 + 81 + 12 + 6 using "my_fun"

my_fun(33, 47, 81, 12, 6)

# Now, let's try just 33 + 47 + 81

my_fun(33, 47, input_4 = 81)

# What happens if we just put 33 into "my_fun"?

my_fun(33)

# If we want to apply a function to a list, vector, matrix, dataframe, etc
# we can use apply(), lapply(), or sapply()

# Read in the Australian weather data again. Create a subset of the 
# first 100 entries


weather <- read.csv("weatherAUS_new.csv")
weather_sub <- weather[1:100, ]


# On this data set, the Rainfall is in millimeters.
# Let's conver that to inches. First, write a function "convert_mm_in".
# Then, us an apply function to do the conversion. 
# 1 mm = 0.0393 inches.

convert_mm_in <- function(mm){
  inches = 0.0393*mm
  return(inches)
}

sapply(weather_sub$Rainfall ,convert_mm_in)

# We can save this output as a data object...

rainfall_in <- sapply(weather_sub$Rainfall ,convert_mm_in)

# ...and add it onto the dataframe

weather_sub$Rainfall_in <- rainfall_in # one way...
weather_sub <- cbind(weather_sub, rainfall_in) # another way...
weather_sub["Rainfall_in_inches"] <- rainfall_in # and another way...


## NESTED LOOPS AND CONDITIONALS
# We hit on this toward the end of lesson 12...but you can NEST loops
# and conditionals together to perform more advanced tasks!

# Let's look at the challenge problem from Lesson 12. We know some of 
# you have already done this, but others probably haven't:

# Members of the West High School Band were hard at
# work practicing for the annual Homecoming Parade.
# First they tried marching in rows of 12, but Andrew was
# left by himself to bring up the rear. Then the director
# told the band members to march in columns of eight,
# but Andrew was still left to march alone. Even when the
# band marched in rows of three, Andrew was left out.
# Finally, in exasperation, Andrew told the band director
# that they should march in rows of five in order to have
# all the rows filled. He was right. Given that there were at
# least 45 musicians on the field but fewer than 200 musicians,
# how many students were there in the West High
# School Band?

# We're aren't going to try coding this yet...let's try to 
# PSEUDOCODE IT TOGETHER!



# Now that we've pseudocoded it...we can code it. Take 5 minutes
# and give it a try!

for (i in 45:200) {
  if (i %% 5 == 0) {
    if (i %% 12 == 1) {
      if (i %% 8 == 1) {
        if (i %% 3 == 1) {
          print(i)
        }
      }
    }
  }
}


# Let's circle back to our weather data.
# A "Cold Day" is when the temperature at 3pm is lower than the 
# temperature at 9am (ie it gets colder as the day goes on)
# We want to see what location has the most "Cold Days".
# Look at each location individually (make it a separate dataframe!).
# Determine if each day is a "Cold Day" or not.
# Then find the total number of "Cold Days". Save them to
# a data structure of your choice. Which location has the most 
# "Cold Days"? 

#gets a list of unique locations
location <- unique(weather$Location)

#creates an empty list for data storage
output <- list()

#iterate through locations
for(i in 1:length(location)){
  
  #create a subset for each location
  subset <- subset(weather, Location == location[i])
  
  #row-by-row, compare the 3pm v. 9am temps
  for(j in 1:length(subset$Date)){
    
    #if 3p < 9a, write yes into a new column
    #if not, write no
    if(subset$Temp3pm[j] < subset$Temp9am[j]){
      subset$ColdDay[j] <- "YES"
    }else{
      subset$ColdDay[j] <- "NO"
    }
  }
  
  #find the total number of cold days for the location
  total <- sum(subset$ColdDay == "YES")
  
  #save it to an output list
  output[i] <- total
}

total_cold_days <- unlist(output)

#create a new df
cold_days <- data.frame(location, total_cold_days)

# look up the location with the most cold days...
cold_days[which.max(cold_days$total_cold_days),]
