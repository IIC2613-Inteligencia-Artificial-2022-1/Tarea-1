% >> Definición del problema <<
% Se resuelve con bound = 10.
rangeX(0..3).
rangeY(0..3).

robot(0).
box(0).

robotOn(0,3,1,0).
boxOn(0,3,3,0,0).

goal(1,2).

obstacle(1,1).
obstacle(2,1..3).