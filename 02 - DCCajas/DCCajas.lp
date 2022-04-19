%% Definir el valor de bound desde la línea de comando!
%% Ejemplo: clingo -c bound=15 DCClue.lp
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


%% Los robots solo pueden moverse 1 celda a la vez (Solo vertival y horizontal)
%   ABAJO
robotOn(R,X,Y+1,T+1) :- exec(R,up,T),robotOn(R,X,Y,T),time(T+1).%, X>=0,X<=#max{S: rangeX(S)},Y>=0,Y<=#max{S: rangeY(S)}.
%   ARRIBA
robotOn(R,X,Y-1,T+1) :- exec(R,down,T),robotOn(R,X,Y,T),time(T+1).%,X>=0,X<=#max{S: rangeX(S)},Y>=0,Y<=#max{S: rangeY(S)}.
%   IZQUIERDA
robotOn(R,X-1,Y,T+1) :- exec(R,left,T),robotOn(R,X,Y,T),time(T+1).%,X>=0,X<=#max{S: rangeX(S)},Y>=0,Y<=#max{S: rangeY(S)}.
%   DERECHA
robotOn(R,X+1,Y,T+1) :- exec(R,right,T),robotOn(R,X,Y,T),time(T+1).%,X>=0,X<=#max{S: rangeX(S)},Y>=0,Y<=#max{S: rangeY(S)}.
%   WAIT
robotOn(R,X,Y,T+1)   :- exec(R,wait,T),robotOn(R,X,Y,T),time(T+1).%,X>=0,X<=#max{S: rangeX(S)},Y>=0,Y<=#max{S: rangeY(S)}.


%% at_goal(R,T) indica que el robot R está en su objetivo en el tiempo T
at_goal(R,B,T) :- robotOn(R,X,Y,T),boxOn(B,X,Y,1,T),goal(X,Y).


%% Los robots y las cajas no deben salirse en ningun momento del mapa
:- robotOn(R,X,Y,T),not rangeX(X).
:- robotOn(R,X,Y,T),not rangeY(Y).

:- boxOn(B,X,Y,Z,T),not rangeX(X).
:- boxOn(B,X,Y,Z,T),not rangeY(Y).


%% No puede haber mas de 1 robot o caja en una celda en el mismo instante de tiempo
:- robotOn(R,X,Y,T),boxOn(B,X,Y,0,T).


%% Los robots no pueden traspasar obstaculos, cajas, ni otros robots
% :- robotOn(R,X,Y,T),obstacle(X,Y).
:- robotOn(R1,X,Y,T),robotOn(R2,X,Y,T), R1!=R2.


%% Los robots no pueden pasar por encima de otros robots (PERMUTAR POSICIONES)
:- robotOn(R1,X,Y,T),robotOn(R2,X+1,Y,T),robotOn(R1,X+1,Y,T+1),robotOn(R2,X,Y,T+1).
:- robotOn(R1,X,Y,T),robotOn(R2,X,Y+1,T),robotOn(R1,X,Y+1,T+1),robotOn(R2,X,Y,T+1).


%% Los robots solo pueden tomar cajas que esten en el suelo (EJE Z) y adyacentes
% 1 { exec(R,take,T) : action(take)} 1 :- boxOn(B,X,Y,0,T),robot(R),time(T+1).
:- exec(R,take,T),not boxOn(B,X,Y+1,0,T),robotOn(R,X,Y,T),time(T),box(B).
:- exec(R,take,T),not boxOn(B,X,Y-1,0,T),robotOn(R,X,Y,T),time(T),box(B).
:- exec(R,take,T),not boxOn(B,X+1,Y,0,T),robotOn(R,X,Y,T),time(T),box(B).
:- exec(R,take,T),not boxOn(B,X-1,Y,0,T),robotOn(R,X,Y,T),time(T),box(B).

% takeOn(R,B,X,Y,T+1),robotOn(R,X,Y,T+1),boxOn(B,X,Y,1,T+1) :- exec(R,take,T),boxOn(B,X,Y+1,0,T),robotOn(R,X,Y,T),time(T+1).
% takeOn(R,B,X,Y,T+1),robotOn(R,X,Y,T+1),boxOn(B,X,Y,1,T+1) :- exec(R,take,T),boxOn(B,X,Y-1,0,T),robotOn(R,X,Y,T),time(T+1).
% takeOn(R,B,X,Y,T+1),robotOn(R,X,Y,T+1),boxOn(B,X,Y,1,T+1) :- exec(R,take,T),boxOn(B,X+1,Y,0,T),robotOn(R,X,Y,T),time(T+1).
% takeOn(R,B,X,Y,T+1),robotOn(R,X,Y,T+1),boxOn(B,X,Y,1,T+1) :- exec(R,take,T),boxOn(B,X-1,Y,0,T),robotOn(R,X,Y,T),time(T+1).

takeOn(R,B,X,Y,T+1) :- robotOn(R,X,Y,T),boxOn(B,X,Y,1,T),time(T+1).

%% Los robots solo pueden llevar una caja a la vez
:- takeOn(R,B1,X,Y,T),takeOn(R,B2,X,Y,T), B1!=B2.
% :- takeOn(R1,B,X,Y,T),takeOn(R2,B,X,Y,T), R1!=R2.


%% goal(R,X,Y,T): definido solo por compatibilidad con el visualizador
goal(R,X,Y,T) :- robot(R),goal(X,Y),time(T).
goal(R,X,Y,0) :- robot(R),goal(X,Y).


%% Se descartan aquellos modelos en los que en el tiempo final el robot no esté en su objetivo:
:- robot(R),box(B), not at_goal(R,B,bound).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TAREA - PARTE 1a): defina el predicado
% stopped_at_goal(R,T): para expresar que R está en el objetivo
% en tiempo T, T+1, T+2, ..., bound

% stopped_at_goal(R,bound) :- at_goal(R,bound).
% stopped_at_goal(R,T) :- at_goal(R,T), stopped_at_goal(R,T+1).

% TAREA - PARTE 1a): escriba una expresión de minimización o
% maximización para expresar que
% se detienen en su objetivo lo antes posible

% #maximize { T,R: stopped_at_goal(R,T), exec(R,wait,T)}.
%#minimize { 1,A,T,R: exec(R,A,T), not wait_action(A), not stopped_at_goal(R,T)}.

% % cada robot puede ejecutar exactamente una acción en cada instante de tiempo
% 1 { exec(R,A,T) : action(A)} 1 :- robot(R),time(T+1).

% Escriba las restriciones que considere necesarias
% suponiendo que:
% rangeX(W): W está dentro del rango del eje X
% rangeY(W): W está dentro del rango del eje Y


#show robotOn/4.
#show boxOn/5.
% #show obstacle/2.
#show rangeX/1.
#show rangeY/1.
#show exec/3.
#show goal/4.

% #show stopped_at_goal/2.