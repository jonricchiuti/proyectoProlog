:- use_module(library(clpfd)).

cargarListaPalabra(_) :-
 	write('Tamano? '),
	read(Tam),
	write('\nAlbafeto? '),
	read(Albafeto),
	write('\nLista de palabras aceptadas? '),
	read(Archivo),
	write('\nLista de palabras rechazadas? '),
	read(Rechazadas),
	open(Archivo,read,Str),
	read(Str,List),
	close(Str),
	verificar(List,Alfabeto),
	generarHechos(Alfabeto),
	palabrasAceptadas(List,Aceptadas),
	hola(Tablero,4,Aceptadas).

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

alguna(Lista,Palabras) :-
	epa(Lista,Palabras);
	verticales(Lista,Palabras).

hola(Lista,X,Aceptadas) :-
	length(Lista,X),
	crearTablero(Lista,X),
	alguna(Lista,Aceptadas),
	mostrarSopa(Lista).

holis([H|T],Palabra,Arbalap) :-
	ver_horizontal(H,Arbalap);
	ver_horizontal(H,Palabra);
	holis(T,Palabra,Arbalap).

epa(_,[]).

epa(Lista,[H|T]) :-
	reverse([H|T],X),
	holis(Lista,H,X),
	epa(Lista,T).
	
verticales(Lista,Palabras) :-
	transpose(Lista,X),
	epa(X,Palabras).


diagonales(Tam,_,Tam,_,_,[]). 

diagonales(I,Tam,Tam,N,Tablero,Diagonal) :-
	Y is I + 1,
	diagonales(Y,0,Tam,N,Tablero,Diagonal).

diagonales(I,J,Tam,N,Tablero,Diagonal) :-
	Cantidad is Tam*2 - 1,
	Numero is Cantidad - N,
	Numero is J + I,
	nth0(I,Tablero,Fila),
	nth0(J,Fila,Miembro),
	Diagonal = [Miembro|T],
	Y is J + 1,
	diagonales(I,Y,Tam,N,Tablero,T).
	 
diagonales(I,J,Tam,N,Tablero,Diagonal) :-
	Y is J + 1,
	diagonales(I,Y,Tam,N,Tablero,Diagonal).

listaDiag(Tablero,Lista) :-
	length(Tablero,X),
	N is X*2-1,
	length(Lista,N),
	extraerDiag(Tablero,Lista,N,X),
	!.

extraerDiag(_,_,0,_).

extraerDiag(Tablero,[H|T],N,Tam) :-
	N > 0,
	diagonales(0,0,Tam,N,Tablero,H),
	N1 is N - 1,
	extraerDiag(Tablero,T,N1,Tam).

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

