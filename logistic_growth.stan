data {
  int<lower=0> N;         // Number of observations
  vector[N] t;            // Time points
  vector[N] P_meas;       // Measured population size
}

parameters {
   real<lower=0> K;        // Carrying capacity
  real<lower=0> r;        // Growth rate
  real<lower=0> sigma;    // Measurement noise
  real<lower=0> P0;       // Initial population size
}

model {
  vector[N] P;
  P[1] = 0.005;  // Initial population size P0

  for (n in 2:N) {
    P[n] = K / (1 + ((K - P[1]) / P[1]) * exp(-r * t[n]));
  }

  // Priors
   K ~ normal(10, 5);        // Prior for K
  r ~ normal(0.5, 0.5);     // Prior for r
  sigma ~ cauchy(0, 2);     // Prior for sigma
  P0 ~ normal(0.005, 0.001); // Prior for P0

  // Likelihood
  P_meas ~ normal(P, sigma);
}
