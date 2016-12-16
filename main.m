Data = csvread('lighthouse.csv')

N = length(Data) % Num Objects
MAX = 1000
obj = struct('u', 0., 'v', 0., 'x', 0., 'y', 0., 'logL', 0., 'logWt', 0.);
Obj = struct([])
Samples = struct([])
for i = 1:N
  Obj(i) = struct(obj);
end
Samples(1) = obj;
logw = 1.;             % ln(width in prior mass
logLstar = 1.;        % ln(Likelihood constraint)
H_ent = 0.5;         % Information, init 0
logZ = log(1e-18);  % ln(Evidence Z, init 0);
logZnew = logZ;         % updated logZ
i = 1;
copy = int32(1);       % Duplicated object
worst = 1;      % Index of worst object
nest = 1;       % Nested sampling iteration count
epochs = 4.0;   % Termination condition nest = end * N * H_ent

% Set prior objects
for i = 1:N  
  Obj(i) = Prior(Obj(i), Data);
end
% Outermost interval of prior mass
logw = log(1. - exp(-1. / N));

%% Begin nested sampling loop
nest = 1;
while (nest <= MAX && nest <= epochs*N*H_ent) 
    % (find) Worst object in collection, with Weight = width * likelihood
    worst = int32(1);
    for i = 1:N
%        i = int32(i)
        if (Obj(i).logL < Obj(worst).logL)  
            worst = i;
        end
    end
    Obj(worst).logWt = logw + Obj(worst).logL;

    logZnew = logplus(logZ, Obj(worst).logWt); % Updating Evindence Z and Information H_ent
    H_ent = exp(Obj(worst).logWt - logZnew) * Obj(worst).logL + exp(logZ - logZnew) * (H_ent + logZ) - logZnew;
    logZ = logZnew;
    
    sampIdx = int32(mod(nest,MAX));
    Samples(sampIdx) = Obj(worst);   % Posterior samples (optional, care with storage overflow;

    flag = (copy == worst && N > 1);
    while (flag)                                  % Kill worst object in favor of copy of different survivor
        copy = int32(N * rand()); %error here? % N;  % force 0 <= copy < N % wtf.
        flag = (copy == worst && N > 1);
    end   % don't kill if N=1 %why?
    logLstar = Obj(worst).logL;         % new likelihood constraint
    Obj(worst) = Obj(copy);             % overwrite worst object

    Obj(worst) = Explore(Obj(worst), logLstar, Data);     % Evolve copied object within constraint
    logw -= 1. / N;                     % Shrink Interval
    printf("%3d | H: %f | Fin: %f \n", nest, H_ent, epochs*N*H_ent); 
    nest++;
end %% end nested sampling loop ============================

printf("logLstar: %f", logLstar);
%% Begin optional final correction, should be small ========
logw = - nest /  N - log( N); % width
for i = 1:N
    Obj(i).logWt = logw + Obj(i).logL; % width * likelihood
    % Update evidence Z and information H_ent
    logZnew = logplus(logZ, Obj(i).logWt);
    H_ent = exp(Obj(i).logWt - logZnew) * Obj(i).logL + exp(logZ - logZnew) * (H_ent + logZ) - logZnew;
    logZ = logZnew;
    % Posterior Samples - overflow risk
%        Samples(nest++) = Obj(i);
end %% end optional final correction

xy_stats = Results(Obj, logZ);
display(xy_stats);