cargarListaPalabra(Alfabeto,Archivo,Tablero) :-
	open(Archivo,read,Str),
	read(Str,List),
	close(Str),
	verificar(List,Alfabeto),
	generarHechos(Alfabeto),
	palabrasAceptadas(List,Aceptadas),
	hola(Tablero,5,Aceptadas),
	epa(Tablero,Aceptadas),
	mostrarSopa(Tablero).

palabrasAceptadas([],[]).

palabrasAceptadas([H|T],[H_|T_]) :-
	atom_chars(H,H_),
	palabrasAceptadas(T,T_).

generarHechos([]).

generarHechos([H|T]) :-
	assert(letra(H)),
	generarHechos(T).

verificar([],_).

verificar([H|T],List) :-
	atom_chars(H,X),
	puedeFormarse(X,List),
	verificar(T,List).

puedeFormarse([],_).

puedeFormarse([H|T],List) :-
	member(H,List),
	puedeFormarse(T,List).

crearColumna(X,Tablero) :- 
	length(Tablero,X),
	rellenarColumna(Tablero).

crearTablero([],_).

crearTablero([H|T],X) :- 
	crearColumna(X,H),
	crearTablero(T,X).

hola(Lista,X,Aceptadas) :-
	length(Lista,X),
	crearTablero(Lista,X).



holis([H|T],Palabra) :-
	ver_horizontal(H,Palabra);
	holis(T,Palabra).

epa(_,[]).

epa(Lista,[H|T]) :-
	holis(Lista,H),
	epa(Lista,T).
	

rellenarColumna([]).

rellenarColumna([H|T]) :-
	letra(H),
	rellenarColumna(T).

mostrarLista([]).

mostrarLista([H|T]) :-
	write(H),
	write(' '),
	mostrarLista(T).

mostrarSopa([]).

mostrarSopa([H|T]) :-
	mostrarLista(H),
	write('\n'),
	mostrarSopa(T).
	

ver_horizontal([],[]).
ver_horizontal([X|Conjunto_tail], [X|Sub_tail]) :-
	ver_horizontal_esp(Conjunto_tail,Sub_tail).
ver_horizontal([_|Conjunto_tail], Sub) :-
	ver_horizontal(Conjunto_tail,Sub).

ver_horizontal_esp(_,[]).
ver_horizontal_esp([X|Conjunto_tail], [X|Sub_tail]) :-
	ver_horizontal_esp(Conjunto_tail,Sub_tail).

