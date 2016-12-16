## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} Explore (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Mike <mm@vit>
## Created: 2016-12-15

function newObj = Explore (obj, logLstar, Data)

step = 0.1;
m = 20;     % MCMC counter
accept = 0; % MCMC acceptances
reject = 0;
%tryObj = struct;
newObj = obj;
tryObj = obj;
while m > 0
  tryObj.u = obj.u + step * (2.*rand()-1);
  tryObj.v = obj.v + step * (2. *rand()-1);
  tryObj.u -= floor(tryObj.u);              % wrap [0,1]
  tryObj.v -= floor(tryObj.v);              % wrap [0,1]
  tryObj.x = 4. * tryObj.u - 2;             % map to x
  tryObj.y = 2. * tryObj.v;
  tryObj.logL = logLhood(tryObj.x, tryObj.y, Data);
  
  if (tryObj.logL > logLstar)
    newObj = tryObj;
    accept++;
  else
    reject++;
  end
  
  if (accept > reject)
    step *= exp(1.0/accept);
  elseif (accept < reject)
    step /= exp(1.0/reject);
  end
  m = m - 1;
end

 
endfunction
