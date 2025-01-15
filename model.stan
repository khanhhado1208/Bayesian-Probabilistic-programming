data {
  int<lower=0> N;       // Number of observations
  vector[N] y;          // Observational data
}

parameters {
  real mu;              // Average
  real<lower=0> alpha;  // Variance
}

model {
   alpha ~ lognormal(0, 0.5); // Prior alpha with small expectation and small variance
  y ~ normal(mu, sqrt(alpha));  // Likelihood distribution
}
