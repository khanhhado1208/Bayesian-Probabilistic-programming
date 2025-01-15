data {
  
  int<lower=0> N_data;
  
  real x_data[N_data];
  vector[N_data] y;
  
  int<lower=0> N_pred;
  real x_pred[N_pred];
}

transformed data {
  
  int<lower=0> N = N_data + N_pred;
  
  real x[N];
  x[1:N_data] = x_data;
  x[(N_data+1):N] = x_pred;
  
  
}

parameters {
  vector[N] eta;

  real<lower=0> alpha;
  real<lower=0> lambda;
  real<lower=0> sigma;
}

transformed parameters {
  
  matrix[N, N] Sigma;
  Sigma = cov_exp_quad(x, alpha, lambda);
  
  // Add nugget on diagonal
  Sigma = Sigma + diag_matrix(rep_vector(1e-6, N));
  matrix[N, N] L = cholesky_decompose(Sigma);
  
  vector[N] f;
  
  f = L*eta;
}

model {
  
  // Likelihood
  y ~ normal(f[1:N_data], sigma); 
  
  // GP prior
  //f ~ multi_normal(rep_vector(0, N), Sigma);
  
  eta ~ normal(0, 1);
  
  alpha ~ gamma(2, 1);
  lambda ~ normal(500, 50);
  sigma ~ gamma(2, 1);
  
}

generated quantities {
   
  vector[N] exp_f;
   exp_f = exp(f);
} 
