function res=precision(nombre)

global eps;
if abs(nombre)<=eps
    res=0;
else
    res=nombre;
end
