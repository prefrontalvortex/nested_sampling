## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} logLhood (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Mike <mm@vit>
## Created: 2016-12-15

function logL = logLhood (x, y, Data)
k = 0;
logL = 0.0;
fin = length;
for k = 1:fin
  numer = log(y/pi);
  denom = (Data(k)-x)^2 + y^2;
  logL = logL + (numer / denom);
end

endfunction
