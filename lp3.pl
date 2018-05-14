:- use_module(naive_sat).

% Test 
check_sum(CNF) :-
    SUM = 2,
    length(A,2),
    length(B,2),
    append([A],[B],NUMBERS),
    sum_equals(SUM,NUMBERS,CNF),
    sat(CNF),
    writeln(NUMBERS).


% Task 1

to_binary(0,[]).

to_binary(N,[H|T]) :-
    H is N mod 2,
    Nn is floor(N / 2),
    to_binary(Nn,T).

to_binary_cnf([],[]).

to_binary_cnf([0|X],[-1|Y]) :-
    to_binary_cnf(X,Y).

to_binary_cnf([1|X],[1|Y]) :-
    to_binary_cnf(X,Y).

get_cnf_rep(SUM,S) :-
    to_binary(SUM,S1),
    to_binary_cnf(S1,S).

sum_equals(SUM,NUMBERS,CNF) :-
    get_cnf_rep(SUM,S),
    sum(NUMBERS,S,CNF).

sum([SUM],SUM,[]).

sum([N1,N2|Nr],SUM,CNF) :-
    add(N1,N2,R,CNF1),
    sum([R|Nr],SUM,CNF2),
    append(CNF1,CNF2,CNF).


fa(X,Y,C,Z,Cn,CNF) :-
    R1 = [-X,-Y,-C,Cn],
    R2 = [-X,-Y,C,Cn],
    R3 = [-X,Y,-C,Cn],
    R4 = [-X,Y,C,-Cn],
    R5 = [X,-Y,-C,Cn],
    R6 = [X,-Y,C,-Cn],
    R7 = [X,Y,-C,-Cn],
    R8 = [X,Y,C,-Cn],
    CNF1 = [R1,R2,R3,R4,R5,R6,R7,R8],
    P1 = [-X,-Y,-C,Z],
    P2 = [-X,-Y,C,-Z],
    P3 = [-X,Y,-C,-Z],
    P4 = [-X,Y,C,-Z],
    P5 = [X,-Y,-C,-Z],
    P6 = [X,-Y,C,Z],
    P7 = [X,Y,-C,Z],
    P8 = [X,Y,C,-Z],
    CNF2 = [P1,P2,P3,P4,P5,P6,P7,P8],
    append(CNF1,CNF2,CNF).


add([],[],[],[]).

add(Xs,Ys,Zs,CNF) :-
    add(Xs,Ys,Zs,-1,CNF).

add([],[],[C],C,[]).

add([X|Xs],[Y|Ys],[Z|Zs],C,CNF) :-
    fa(X,Y,C,Z,Cn,CNF1),
    add(Xs,Ys,Zs,Cn,CNF2),
    append(CNF1,CNF2,CNF).


% task 2 

 direct(Xs,N,CNF):-   
    length(Xs, N),
    one_hot(Xs, CNF1),
    append([Xs], CNF1, CNF).

one_hot([_], []).

one_hot([X, Y |Xs], CNF):-
    one_hot([X | Xs], CNF1),
    one_hot([Y | Xs], CNF2),
    append([[[-X, -Y]], CNF1, CNF2], CNF).


diff(Xs,Ys,[[B]|Cnf]):-
    diff(B, Xs, Ys, Cnf).

diff(B, [X], [Y], CNF):-
    P1 = [-B, -X, -Y],
    P2 = [-B, X, Y],
    P3 = [B, -X, Y],
    P4 = [B, X, -Y],
    CNF = [P1,P2,P3,P4].

diff(B, [X|Xs], [Y|Ys], CNF):-
    P1 = [-B, -X, -Y, B1],
    P2 = [-B, X, Y, B1],
    P3 = [B, -X, Y],
    P4 = [B, X, -Y],
    P5 = [B, -B1],
    CNF1 = [P1,P2,P3,P4,P5],
    diff(B1, Xs, Ys, CNF2),
    append(CNF1, CNF2, CNF).


diff(_, [], [], []).


all_diff([], []). 
all_diff([X],CNF):-
    direct(X, 4, CNF).

all_diff([X, Y|Ys],CNF):-
    direct(X, 4, CNF1),
    direct(Y, 4, CNF2),
    diff(X, Y, CNF3),
    all_diff([X|Ys], CNF4),
    all_diff([Y|Ys], CNF5),   
    append([CNF1, CNF2, CNF3, CNF4, CNF5], CNF).

% task 3



for_each_pair([],[]).

for_each_pair([ _ = L|T],CNF) :-
    all_diff(L,CNF1),
    for_each_pair(T,CNF2),
    append(CNF1,CNF2,CNF).

kakuroVerify(X) :-
    for_each_pair(X,CNF)
    sat(CNF),
    writeln(X).