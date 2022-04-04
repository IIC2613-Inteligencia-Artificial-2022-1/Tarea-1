tiempo(1..6).

persona(nacho).
persona(nico).
persona(felipe).

personaEnLugar(felipe, metro, 4).

% En este caso, el culpable es nico, ya que solamente uno puede mentir y hay 2 personas dando la 
% misma versión, mientras que el la contradice
afirmacionLugar(nacho, nico, cai, 1).
afirmacionLugar(felipe, nico, cai, 1).
afirmacionLugar(nico, felipe, cai, 1).

descubrimiento(metro, 5).
