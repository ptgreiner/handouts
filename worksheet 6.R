## lm

animals <- read.csv('data/animals.csv', stringsAsFactors = FALSE, na.strings = '')
fit <- lm(
  log(weight) ~hindfoot_length,
  data = animals)

##exercise 1
exercise1<- filter(animals, species_id=="DM")
exercise1m<- lm(hindfoot_length ~ log(weight), data=exercise1)
exercise1mfull<- lm(hindfoot_length ~ log(weight), data=animals)

summary(exercise1m)
summary(exercise1mfull)

animals$species_id <- factor(animals$species_id)
fited <- lm(hindfoot_length~
  weight + species_id,
  data = animals)

fited <- lm(weight ~ species_id,
            data = animals)
summary(fited)
## glm

##exercise 2
fitglm <- glm(
  weight ~species_id,
  data = animals)
summary(fitglm)

animals$sex <- factor(animals$sex)
fitlogit <- glm(sex ~ hindfoot_length,
           family= binomial,
           data = animals)

summary(fitlogit)


## lme4

# install.packages('lme4')

library(lme4)
fit <- lmer(...,
            data = animals)

fitran_intercept <- lmer(log(weight)~ (1|species_id)+ hindfoot_length,
            data = animals)
summary(fitran_intercept)

##exercise4
exercise4<-lmer()

## RStan

library(dplyr)
library(rstan)
stanimals <- animals %>%
  select(weight, species_id, hindfoot_length) %>%
  na.omit() %>%
  mutate(log_weight = log(weight),
         species_idx = as.integer(factor(species_id))) %>%
  select(-weight, -species_id)
stanimals <- c(
  N = nrow(stanimals),
  M = max(stanimals$species_idx),
  as.list(stanimals))

samp <- stan(file = 'worksheet-6.stan',
             data = stanimals,
             iter = 1000, chains = 3)
saveRDS(samp, 'stanimals.RDS')