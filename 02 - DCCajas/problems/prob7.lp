% >> Definición del problema <<
% Se resuelve con bound = 13.
rangeX(0..3).
rangeY(0..3).

robot(0..1).
box(0..1).

robotOn(0,3,0,0).
robotOn(1,3,1,0).

boxOn(0,3,2,0,0).
boxOn(1,3,3,0,0).

goal(0,3).
goal(1,3).

obstacle(1,1..2).
obstacle(1..2,1).
obstacle(2,3).