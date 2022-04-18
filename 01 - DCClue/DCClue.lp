lugar(cai).
lugar(deportes).
lugar(biblioteca).
lugar(metro).
lugar(dcc).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
camino(metro, cai).
camino(metro, dcc).
camino(dcc, biblioteca).
camino(dcc, cai).
camino(cai, deportes).
camino(deportes, biblioteca).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problema 1
tiempo(1..10).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
persona(nacho).
persona(nico).
persona(felipe).
persona(fernando).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % En este caso, usando el mapa 1, el culpable es nico
personaEnLugar(nico, cai, 1).
personaEnLugar(fernando, cai, 5).
afirmacionLugar(nico, fernando, deportes, 5).
descubrimiento(metro, 7).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Caminos recorribles en ambas direcciones.
camino(Y, X) :- camino(X, Y).

% Un lugar esta conectado consigo mismo (camino).
camino(X, X) :- lugar(X).


% El culpable es el unico que puede mentir -> Contradecir informacion
% El culpable debe haber estado en el lugar del crimen antes del tiempo del descubrimiento
culpable(X) :- personaEnLugar(X,Y,1..T-1) descubrimiento(Y,T), tiempo(T)

% Los presuntos inocentes no pueden mentir
%% No puede afirmar que una persona estuvo en dos lugares en momentos tales que no haya suficiente tiempo como para que sea posible desplazarse
mentira(P1) :- 