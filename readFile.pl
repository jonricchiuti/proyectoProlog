:- use_module(library(clpfd)).

parar(no).

main :-
	write('Tamano? '),
	read(Tam),
	write('Alfabeto? '),
	read(Alfabeto),
	write('Archivo de palabras aceptadas? '),
	read(Aceptadas),
	write('Archivo de palabras rechazadas? '),
	read(Rechazadas),
	cargarListaPalabra(Aceptadas,Lista),
	cargarListaPalabra(Rechazadas,ListaR),
	%% verificar(Lista,Alfabeto),
	%% verificar(ListaR,Alfabeto),
	generarHechos(Alfabeto),
	palabrasAceptadas(Lista,Acept),
%	palabrasAceptadas(ListaR,Recha),
	hola(Tablero,Tam,Acept,Recha,Respuesta),
	parar(Respuesta),!,
	fail.

main :- 
	write('Gracias!').

cargarListaPalabra(Archivo,Lista) :-
	open(Archivo,read,Str),
	read(Str,Lista),
	close(Str).

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
	verticales(Lista,Palabras);
	diagonalesUBLR(Lista,Palabras);
	diagonalesBURL(Lista,Palabras).

hola(Lista,X,Aceptadas,Rechazadas,Respuesta) :-
	length(Lista,X),
	crearTablero(Lista,X),
%	negarPalabras(Lista,Rechazadas),
%	verificarPalabras(Lista,Aceptadas),
	mostrarSopa(Lista),
	write('\nQuieres mas? '),
	read(Respuesta).

holis([H|T],Palabra,Arbalap) :-
	ver_horizontal(H,Arbalap);
	ver_horizontal(H,Palabra);
	holis(T,Palabra,Arbalap).

%-----------------------------------
vertical(Tablero,Palabra) :-
	reverse(Palabra,Arbalap),
	transpose(Tablero,X),
	holis(X,Palabra,Arbalap).

horizontal(Tablero,Palabra) :-
	reverse(Palabra,Arbalap),
	holis(Tablero,Palabra,Arbalap).

diagonalUBLR(Tablero,Palabra) :-
	reverse(Palabra,Arbalap),
	listaDiag(Tablero,Diags),
	holis(Diags,Palabra,Arbalap).
	
diagonalBURL(Tablero,Palabra) :-
	reverse(Palabra,Arbalap),
	reverse(Tablero,X),
	listaDiag(X,Diags),
	holis(Diags,Palabra,Arbalap).

verificarPalabras(_,[]).

verificarPalabras(Tablero,[H|T]) :-
	(horizontal(Tablero,H);
	vertical(Tablero,H);
	diagonalUBLR(Tablero,H);
	diagonalBURL(Tablero,H)),
	verificarPalabras(Tablero,T).
	
negarPalabras(Tablero,[H|T]) :-
	not(verificarPalabras(Tablero,[H|T])).

%-------------------------------------

diagonal(Tam,_,Tam,_,_,[]). 

diagonal(I,Tam,Tam,N,Tablero,Diagonal) :-
	Y is I + 1,
	diagonal(Y,0,Tam,N,Tablero,Diagonal).

diagonal(I,J,Tam,N,Tablero,Diagonal) :-
	Cantidad is Tam*2 - 1,
	Numero is Cantidad - N,
	Numero is J + I,
	nth0(I,Tablero,Fila),
	nth0(J,Fila,Miembro),
	Diagonal = [Miembro|T],
	Y is J + 1,
	diagonal(I,Y,Tam,N,Tablero,T).
	 
diagonal(I,J,Tam,N,Tablero,Diagonal) :-
	Y is J + 1,
	diagonal(I,Y,Tam,N,Tablero,Diagonal).

listaDiag(Tablero,Lista) :-
	length(Tablero,X),
	N is X*2-1,
	length(Lista,N),
	extraerDiag(Tablero,Lista,N,X),
	!.

extraerDiag(_,_,0,_).

extraerDiag(Tablero,[H|T],N,Tam) :-
	N > 0,
	diagonal(0,0,Tam,N,Tablero,H),
	N1 is N - 1,
	extraerDiag(Tablero,T,N1,Tam).

diagonalesUBLR(Tablero,[H|T]) :-
	reverse(H,X),
	listaDiag(Tablero,Diags),
	holis(Diags,H,X);
	diagonalesUBLR(Tablero,T).

diagonalesBURL(Tablero,List) :-
	reverse(Tablero,X),
	diagonalesUBLR(X,List).

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

