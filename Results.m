## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} Results (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Mike <mm@vit>
## Created: 2016-12-15

function retval = Results (Samples, logZ)
% Samples are the posterior objects
x=0.;
xx=0.;
y=0.
yy=0.
w=0.
i = 1
for i = 1:length(Samples)
  w = exp(Samples(i).logWt - logZ);
  x  += w * Samples(i).x;
  xx += w * (Samples(i).x)^2;
  y  += w * Samples(i).y;
  yy += w * (Samples(i).y)^2;
end

sprintf("Mean x = %.3f", x);
sprintf("Mean y = %.3f", y);

retval = struct('x_mean', x, 'y_mean', y, 'x_std', (xx-x.^2), 'y_std', (yy-y.^2));
  

endfunction
