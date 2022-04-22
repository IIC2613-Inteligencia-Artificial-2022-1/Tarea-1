%% Definir el valor de bound desde la línea de comando!
%% Ejemplo: clingo -c bound=15 DCCajas.lp

time(1..bound).

% hay 6 acciones posibles
action(up).
action(down).
action(left).
action(right).
action(wait).
action(take).


%   SOLO SE EJECUTA UNA ACCION
1 { exec(R,A,T) : action(A)} 1 :- robot(R),time(T+1).
:- exec(R,take,T0),exec(R,take,T1),T0<T1.


%% Los robots solo pueden moverse 1 celda a la vez (Solo vertival y horizontal)
robotOn(R,X,Y+1,T+1) :- exec(R,up,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y-1,T+1) :- exec(R,down,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X-1,Y,T+1) :- exec(R,left,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X+1,Y,T+1) :- exec(R,right,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y,T+1)   :- exec(R,wait,T),robotOn(R,X,Y,T),time(T+1).

%,X>=0,X<=#max{S: rangeX(S)},Y>=0,Y<=#max{S: rangeY(S)}.

%% at_goal(R,B,T) indica que el robot R está en su objetivo con la caja B en el tiempo T 
at_goal(R,B,T) :- robotOn(R,X,Y,T),boxOn(B,X,Y,1,T),goal(R,B,X,Y).
% at_goal(R,B,T) :- robotOn(R,X,Y,T),boxOn(B,X,Y,1,T),goal(X,Y).


%% Los robots y las cajas no deben salirse en ningun momento del mapa
:- robotOn(R,X,Y,T),not rangeX(X).
:- robotOn(R,X,Y,T),not rangeY(Y).

:- boxOn(B,X,Y,Z,T),not rangeX(X).
:- boxOn(B,X,Y,Z,T),not rangeY(Y).


%% No puede haber mas de 1 robot o caja en una celda en el mismo instante de tiempo
:- robotOn(R,X,Y,T),boxOn(B,X,Y,0,T).


%% Los robots no pueden traspasar obstaculos, cajas, ni otros robots
:- robotOn(R,X,Y,T),obstacle(X,Y).
:- robotOn(R1,X,Y,T),robotOn(R2,X,Y,T), R1!=R2.


%% Los robots no pueden pasar por encima de otros robots (PERMUTAR POSICIONES)
:- robotOn(R1,X,Y,T),robotOn(R2,X+1,Y,T),robotOn(R1,X+1,Y,T+1),robotOn(R2,X,Y,T+1),R1!=R2.
:- robotOn(R1,X,Y,T),robotOn(R2,X,Y+1,T),robotOn(R1,X,Y+1,T+1),robotOn(R2,X,Y,T+1),R1!=R2.


%% Los robots solo pueden tomar cajas que esten en el suelo (EJE Z) y adyacentes
robotOn(R,X,Y,T+1) :- exec(R,take,T),boxOn(B,X,Y+1,0,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y,T+1) :- exec(R,take,T),boxOn(B,X,Y-1,0,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y,T+1) :- exec(R,take,T),boxOn(B,X+1,Y,0,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y,T+1) :- exec(R,take,T),boxOn(B,X-1,Y,0,T),robotOn(R,X,Y,T),time(T+1).

takeOn(R,B,T) :- exec(R,take,T),boxOn(B,X,Y+1,0,T),robotOn(R,X,Y,T).
takeOn(R,B,T) :- exec(R,take,T),boxOn(B,X,Y-1,0,T),robotOn(R,X,Y,T).
takeOn(R,B,T) :- exec(R,take,T),boxOn(B,X+1,Y,0,T),robotOn(R,X,Y,T).
takeOn(R,B,T) :- exec(R,take,T),boxOn(B,X-1,Y,0,T),robotOn(R,X,Y,T).

boxOn(B,X,Y,1,T1) :- takeOn(R,B,T0),robotOn(R,X,Y,T1),T0<T1. 

1{goal(R,B,X,Y):goal(X,Y)}1 :- takeOn(R,B,T).


%% Los robots solo pueden llevar una caja a la vez
:- takeOn(R,B1,_),takeOn(R,B2,_),B1!=B2.


%% Se descartan aquellos modelos en los que en el tiempo final el robot no esté en su objetivo:
:- robot(R),box(B),not at_goal(R,B,bound).


%% Continuidad de una caja que se encuentra en el piso.
boxOn(B,X,Y,0,T) :- boxOn(B,X,Y,0,0),not boxOn(B,_,_,1,T),time(T).


% #show rangeX/1.
% #show rangeY/1.
% #show time/1.
% #show goal/2.
% #show obstacle/2.
% #show robotOn/4.
% #show boxOn/5.

% #show at_goal/3.
% #show takeOn/3.
% #show exec/3.
% #show goal/4.