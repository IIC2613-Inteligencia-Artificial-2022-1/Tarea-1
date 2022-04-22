% Un lugar esta conectado consigo mismo (camino).
camino(X, X) :- lugar(X).

% Caminos de largo > 1
camino (X,Z) :- camino(X,Y),camino(Y,Z).

% Caminos recorribles en ambas direcciones.
camino(Y, X) :- camino(X, Y).

% El culpable es el unico que puede mentir -> Contradecir informacion
% El culpable debe haber estado en el lugar del crimen antes del tiempo del descubrimiento
culpable(P) :- personaEnLugar(P,L,T0), descubrimiento(L,T1),T0<T1.
culpable(P) :- mentira(P).


% Los presuntos inocentes no pueden mentir
%% No puede afirmar que una persona estuvo en dos lugares en momentos tales que no haya suficiente tiempo como para que sea posible desplazarse
mentira(P1) :- afirmacionLugar(P1,P2,L1,T1),afirmacionLugar(P1,P2,L2,T2).

%% No puede decir que hay 2 personas en un mismo lugar
mentira(P1) :- afirmacionLugar(P1,P2,L,T),afirmacionLugar(P1,P3,L,T),P2!=P3.

%% No puede decir que alguien estaba en un lugar si ya sabemos que estaba en otro
mentira(P1) :- afirmacionLugar(P1,P2,L1,T),personaEnLugar(P2,L2,T),L1!=L2.

%% No "pueden" dar versiones distintas sobre ubicacion de una persona en un instante


%% No puede decir que alguien estaba en 2 lugares en el mismo instante
mentira(P1) :- afirmacionLugar(P1,P2,L1,T),afirmacionLugar(P1,P2,L2,T),L1!=L2. 


%% Sospechosos
sospechoso(P1) :- .


% #show culpable/1.
% #show sospechoso/1.
% #show personaEnLugar/3.

% #show camino/2.