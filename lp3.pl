:- use_module(naive_sat).

% Test 
check_sum(CNF) :-
    SUM = 12,
    length(A,4),
    length(B,4),
    append(A,B,NUMBERS),
    sum_equals(SUM,NUMBERS,CNF).


% Task 1


to_binary(0,[]).

to_binary(N,[H|T]) :-
    H is N mod 2,
    Nn is floor(N / 2),
    to_binary(Nn,T).

sum_equals(SUM,NUMBERS,CNF) :-
    to_binary(SUM,S),
    sum(NUMBERS,S,CNF).

sum([R],R,[]).

sum([N1,N2|Nr],S,CNF) :-
    add(N1,N2,R,CNF1),
    sum([R|Nr],S,CNF2),
    append(CNF1,CNF2,CNF).


fa(X,Y,C,Z,Cn,CNF) :-
    R1 = [-X,-Y,-C,Cn],
    R2 = [-X,-Y,C,Cn],
    R3 = [-X,Y,-C,CN],
    R4 = [-X,Y,C,-Cn],
    R5 = [X,-Y,-C,CN],
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
    onlyOneBit(Xs, CNF1),
    append([Xs], CNF1, CNF).

onlyOneBit([_], []).

onlyOneBit([X, Y |Xs], CNF):-
    onlyOneBit([X | Xs], CNF1),
    onlyOneBit([Y | Xs], CNF2),
    append([[[-X, -Y]], CNF1, CNF2], CNF).


diff(Xs,Ys,[[B]|Cnf]):-
    diff(B, Xs, Ys, Cnf).

diff(B, [X], [Y], CNF):-
    CNF = [[-B, -X, -Y], [-B, X, Y], [B, -X, Y], [B, X, -Y]].

diff(B, [X|Xs], [Y|Ys], CNF):-
    CNF1 = [[-B, -X, -Y, B1], [-B, X, Y, B1], [B, -X, Y], [B, X, -Y], [B, -B1]],
    diff(B1, Xs, Ys, CNF2),
    append(CNF1, CNF2, CNF).


diff(_, [], [], []).


all_diff([], _, []). 
all_diff([X],N,CNF):- direct(X, N, CNF).

all_diff([X, Y|Ys],N,CNF):-
    direct(X, N, CNF1),
    direct(Y, N, CNF2),
    diff(X, Y, CNF3),
    all_diff([X|Ys], N, CNF4),
    all_diff([Y|Ys], N, CNF5),   
    append([CNF1, CNF2, CNF3, CNF4, CNF5], CNF).


% task 3

% kakuroPair(C,L).

% for_each_pair([],_).

% for_each_pair([kakuroPair(_,L)|T],P) :-
%     call(P,L),
%     for_each_pair(T,P).

% kakuroVerify(X) :-
%     for_each_pair(X,all_diff),
%     for_each(X,sum)
