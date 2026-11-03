# Atlanta Marijuana Decriminalization and Crime Rates

An exploratory Stata workflow for estimating the association between Atlanta's
2017 marijuana decriminalization and agency-level violent and property crime
rates using a difference-in-differences design.

## Research design

The analysis compares Atlanta (identified by the source data's `treated`
indicator) with untreated agencies in metropolitan areas where recreational
marijuana remained illegal and the city had not decriminalized marijuana. The
analysis window starts in 2010; 2017 is the first post-policy year.

The do-file applies those sample restrictions, plots group trends, and
estimates a separate two-way fixed-effects model for each crime-rate outcome.
Agency fixed effects account for time-invariant differences between agencies,
year effects account for shocks shared across agencies, and standard errors
are clustered by agency.

This is an exploratory analysis, not a validated causal finding. In particular,
the treated group in the source file appears to contain only one agency. With
only one treated cluster, conventional cluster-robust inference is not
reliable. Pre-policy trend plots are descriptive and cannot establish the
parallel-trends assumption. Results should not be interpreted as causal without
addressing these limitations and validating the treatment and comparison
groups.

## Data

Raw data are intentionally not included. The source file's provenance and
redistribution terms have not been verified.

To run the analysis, obtain a properly licensed copy of the agency-level crime
panel, verify its source and variable definitions, and place it at:

```text
data/annual_crime_data.dta
```

The dataset must contain these variables:

- `agency_id`, `agency_name`, `state`, `year`
- `treated`, `state_legalREC`, `city_decrim`, `met2013`, `mean_pop`
- `vio_rate`, `prop_rate`

The do-file retains the treated agency and restricts comparison agencies to
those with `mean_pop > 100000`, non-missing metropolitan-area identifiers, no
city-level decriminalization, and states where recreational marijuana remained
illegal. Keeping the treated agency separate from the control-group
restrictions is essential; applying the control criteria to treated
observations could remove the policy's post-period data. Confirm that these
definitions match the data source and study period before interpreting output.

## Run

Requires Stata with support for factor-variable notation and `areg`.

From the repository root in Stata, run:

```stata
do analysis.do
```

The script writes a Stata log and two trend charts to the repository root.
These generated files and the local data directory are ignored by Git.

## Repository scope

This repository contains an independently cleaned analysis script and
documentation only. It excludes the original course prompt, class handouts,
student logs, generated tables, and raw data. No empirical findings are
reported here because the data source and analysis have not been independently
validated.
