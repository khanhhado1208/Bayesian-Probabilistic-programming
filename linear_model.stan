data {
  int<lower=0> N; // Sample size
  vector[N] x; // x-values
  vector[N] y; // y-values
}
parameters {
  real alpha; // intercept
  real beta;  // slope
  real<lower=0> sigma; // noise
}

model {
  
  // Likelihood
  // for(i in 1:N) {
  //   y[i] ~ normal(alpha + beta * x[i], sigma);
  // }
  
  // Likelihood can be vectorized. This is equivalent to the for loop above. 
  y ~ normal(alpha + beta * x, sigma);
  
  // Priors
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma ~ gamma(2, 1);
}

generated quantities {
  
  vector[N] y_tilda;
  
  for(i in 1:N) {
    y_tilda[i] = normal_rng(alpha + beta*x[i], sigma);
  }
  
}
