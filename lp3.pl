:- use_module(naive_sat).

% Test 
check_sum(CNF) :-
    SUM = 15,
    length(A,4),
    length(B,4),
    append([A],[B],NUMBERS),
    sum_equals(SUM,NUMBERS,CNF).


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