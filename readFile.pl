main :-
  open('aceptadas.txt',read,Str),
  read(Str,Lines),
  close(Str),
  write(Lines), nl.

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
