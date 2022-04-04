tiempo(1..5).

% 3 personas
persona(nacho).
persona(nico).
persona(felipe).

% Sabemos que nico estaba en el cai al instante 1
personaEnLugar(nico, cai, 1).

% Afirmaciones de personas sobre lugares y tiempos
afirmacionLugar(nacho, nico, cai, 1).
afirmacionLugar(felipe, nico, cai, 1).
afirmacionLugar(nico, nico, biblioteca, 2).

% Se descubre el crimen en el cai en el tiempo 3
descubrimiento(cai, 3).

% Respuesta: Nico es el culpable, porque no pudo haber llegado del cai a la biblioteca en un tiempo