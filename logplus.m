## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} logplus (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Mike <mm@vit>
## Created: 2016-12-15

## Equivalent to log(exp(x) + exp(y))

function retval = logplus (x, y)

if x > y
  retval = x + log(1+exp(y-x));
else
  retval = y + log(1+exp(x-y));
end

endfunction
