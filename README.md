# Marijuana Decriminalization and Crime in Atlanta

A difference in differences analysis from ECO 362, Research Seminar in Crime and Punishment, Berry College, Spring 2025.

## Question

Did Atlanta's 2017 marijuana decriminalization change violent or property crime rates relative to comparable police agencies?

## Why it matters

Easing marijuana enforcement is often debated in terms of its effect on more serious crime. Atlanta is a large city with a clear policy date, which allows a before and after comparison against agencies that did not change their policy.

## Data

Annual agency level crime rates, 2010 onward. The data file is not included because its source and redistribution terms have not been verified. To run the analysis, place a properly licensed copy at `data/annual_crime_data.dta` with these variables: `agency_id`, `agency_name`, `state`, `year`, `treated`, `state_legalREC`, `city_decrim`, `met2013`, `mean_pop`, `vio_rate`, `prop_rate`.

## Method

Atlanta is the treated agency. Comparison agencies serve more than 100,000 people, sit in metropolitan areas, have no city level decriminalization, and are in states where recreational marijuana remained illegal. Each outcome is estimated with a two way fixed effects model (agency and year effects), with standard errors clustered by agency. The script also plots pre and post trends for both groups.

## Limitations

Only one agency is treated, so cluster robust standard errors are unreliable, and pre policy trend plots cannot confirm parallel trends. The estimates are exploratory and should not be read as causal. No results are reported in this repository.

## Run

In Stata, from the repository root:

```stata
do analysis.do
```

The script writes a log and two trend charts to the repository root. These files and the local data folder are ignored by Git.
