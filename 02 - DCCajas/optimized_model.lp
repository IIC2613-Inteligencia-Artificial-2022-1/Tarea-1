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
% Solo se puede ejecutar take una vez
:- exec(R,take,T0),exec(R,take,T1),T0<T1.


%% Los robots solo pueden moverse 1 celda a la vez (Solo vertival y horizontal)
robotOn(R,X,Y-1,T+1) :- exec(R,up,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y+1,T+1) :- exec(R,down,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X-1,Y,T+1) :- exec(R,left,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X+1,Y,T+1) :- exec(R,right,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y,T+1)   :- exec(R,wait,T),robotOn(R,X,Y,T),time(T+1).


%% at_goal(B,T) indica que la caja B está en su objetivo en el tiempo T 
at_goal(B,T) :- robotOn(R,X,Y,T),boxOn(B,X,Y,1,T),goal(R,B,X,Y,T).


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
% Comportamiento del robot cuando EXEC()
robotOn(R,X,Y,T+1) :- exec(R,take,T),boxOn(B,X,Y+1,0,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y,T+1) :- exec(R,take,T),boxOn(B,X,Y-1,0,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y,T+1) :- exec(R,take,T),boxOn(B,X+1,Y,0,T),robotOn(R,X,Y,T),time(T+1).
robotOn(R,X,Y,T+1) :- exec(R,take,T),boxOn(B,X-1,Y,0,T),robotOn(R,X,Y,T),time(T+1).

% Definicion de takeOn -> Relacion entre el robot y la caja tomada
takeOn(R,B,T) :- exec(R,take,T),boxOn(B,X,Y+1,0,T),robotOn(R,X,Y,T).
takeOn(R,B,T) :- exec(R,take,T),boxOn(B,X,Y-1,0,T),robotOn(R,X,Y,T).
takeOn(R,B,T) :- exec(R,take,T),boxOn(B,X+1,Y,0,T),robotOn(R,X,Y,T).
takeOn(R,B,T) :- exec(R,take,T),boxOn(B,X-1,Y,0,T),robotOn(R,X,Y,T).

% Comportamiento de la caja tomada segun las acciones del robot que la lleva
boxOn(B,X,Y-1,1,T+1) :- exec(R,up,T),takeOn(R,B,_),boxOn(B,X,Y,1,T),time(T+1).
boxOn(B,X,Y+1,1,T+1) :- exec(R,down,T),takeOn(R,B,_),boxOn(B,X,Y,1,T),time(T+1).
boxOn(B,X-1,Y,1,T+1) :- exec(R,left,T),takeOn(R,B,_),boxOn(B,X,Y,1,T),time(T+1).
boxOn(B,X+1,Y,1,T+1) :- exec(R,right,T),takeOn(R,B,_),boxOn(B,X,Y,1,T),time(T+1).
boxOn(B,X,Y,1,T+1) :- exec(R,wait,T),takeOn(R,B,_),boxOn(B,X,Y,1,T),time(T+1).
boxOn(B,X,Y,1,T+1) :- exec(R,take,T),takeOn(R,B,T),boxOn(B,_,_,0,T),robotOn(R,X,Y,T),time(T+1).

% Definicion del objetivo de la caja cuando es tomada
1{goal(R,B,X,Y,T):goal(X,Y)}1 :- takeOn(R,B,T).
goal(R,B,X,Y,T+1) :- goal(R,B,X,Y,T),time(T+1).


%% Los robots solo pueden llevar una caja a la vez
:- takeOn(R,B1,_),takeOn(R,B2,_),B1!=B2.


%% Una caja puede ser tomada 1 vez
:- takeOn(R1,B,_),takeOn(R2,B,_),R1!=R2.


%% Se descartan aquellos modelos en los que en el tiempo final la caja no esté en su objetivo:
:- box(B),not at_goal(B,bound).


%% Continuidad de una caja que se encuentra en el piso.
boxOn(B,X,Y,0,T) :- boxOn(B,X,Y,0,0),not boxOn(B,_,_,1,T),time(T).


%% Continuidad de los robots
:- robot(R),not robotOn(R,_,_,T),time(T).


%% ACTIVIDAD2: ROBOTS PROCASTINADORES
stopped_at_goal(B,bound) :- at_goal(B,bound).
stopped_at_goal(B,T) :- at_goal(B,T), stopped_at_goal(B,T+1).

#maximize { T,B: stopped_at_goal(B,T)}.



%% Atomos requeridos por 'process.py'
#show rangeX/1.
#show rangeY/1.
#show time/1.
#show goal/2.
#show obstacle/2.
#show robotOn/4.
#show boxOn/5.

%% Atomos de debugging
% #show at_goal/2.
% #show takeOn/3.
% #show exec/3.
% #show goal/4.

% #show at_goal/3.
% #show stopped_at_goal/2.