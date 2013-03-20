cargarListaPalabra(Alfabeto,Archivo) :-
  open(Archivo,read,Str),
  read(Str,List),
  close(Str),
  verificar(List,Alfabeto).

verificar([],_).

verificar([H|T],List) :-
  atom_chars(H,X),
  puedeFormarse(X,List),
  verificar(T,List).

puedeFormarse([],_).

puedeFormarse([H|T],List) :-
  member(H,List),
  puedeFormarse(T,List).

holaSusana([],_).

holaSusana([X|T],Z) :-
  length(X,5),
  holaSusana(T,Z).

crearTablero(0,[]).

crearTablero(X,Tablero) :- 
  length(Tablero,X),
  holaSusana(Tablero,X).
  
