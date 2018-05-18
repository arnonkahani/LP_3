:- use_module(naive_sat).

% Test 
check_sum() :-
    % SUM = 5,
    length(A,5),
    length(B,5),
    append([A],[B],NUMBERS),
    sum_equals(9,NUMBERS,CNF),
    sat(CNF),
    writeln(NUMBERS).

check_sum_2() :-
    length(A,4),
    length(B,4),
    add(A,B,R,CNF),
    sat(CNF),
    writeln(A),
    writeln(B),
    writeln(R).

check_sum_3() :-
    fa(X,Y,C,Z,Cn,CNF),
    sat(CNF),
    writeln(X),
    writeln(Y),
    writeln(C),
    writeln(Z),
    writeln(Cn).

check_sum_4() :-
    length(Xs,4),
    length(Ys,4),
    add(Xs,Ys,SUM,CNF),
    sat(CNF),
    writeln(Xs),
    writeln(Ys),
    writeln(SUM).

instance(1,[15=[9,1,5],10=[8,2]]).

instance(2,[15=[X1,X2,X3],10=[X2,X4]]).

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
    to_binary_cnf(S1,S),!.

equal_vec([H],[H]).

equal_vec([H|Ys],[H|Xs]) :-
    equal_vec(Ys,Xs).

sum_equals(SUM,NUMBERS,CNF) :-
    get_cnf_rep(SUM,S),
    sum(NUMBERS,S,CNF).

sum([X],SUM,[]) :-
    append(SUM,-1,Sn),
    equal_vec(Sn,X).


sum([N1,N2],SUM,CNF) :-
    add(N1,N2,R,CNF1),
    writeln(R),
    writeln(SUM),
    sum([R],SUM,CNF2),
    append(CNF1,CNF2,CNF).

sum([N1,N2|Nr],SUM,CNF) :-
    add(N1,N2,R,CNF1),
    sum([R|Nr],SUM,CNF2),
    append(CNF1,CNF2,CNF).




fa(X,Y,C,S,Cn,CNF) :-
    R1 = [-X,-Y,-C,Cn],
    R2 = [-X,-Y,C,Cn],
    R3 = [-X,Y,-C,Cn],
    R4 = [-X,Y,C,-Cn],
    R5 = [X,-Y,-C,Cn],
    R6 = [X,-Y,C,-Cn],
    R7 = [X,Y,-C,-Cn],
    R8 = [X,Y,C,-Cn],
    CNF1 = [R1,R2,R3,R4,R5,R6,R7,R8],
    P1 = [-X,-Y,-C,S],
    P2 = [-X,-Y,C,-S],
    P3 = [-X,Y,-C,-S],
    P4 = [-X,Y,C,S],
    P5 = [X,-Y,-C,-S],
    P6 = [X,-Y,C,S],
    P7 = [X,Y,-C,S],
    P8 = [X,Y,C,-S],
    CNF2 = [P1,P2,P3,P4,P5,P6,P7,P8],
    append(CNF1,CNF2,CNF).


add([],[],[],[]).

add(Xs,Ys,SUM,CNF) :-
    add(Xs,Ys,-1,SUM,CNF).

add([],[],C,[C],[]).

add([X],[Y],C,[SUM|Cn],CNF) :-
    fa(X,Y,C,SUM,Cn,CNF).

add([X|Xs],[Y|Ys],C,[S|SUM],CNF) :-
    fa(X,Y,C,S,Cn,CNF1),
    add(Xs,Ys,Cn,SUM,CNF2),
    append(CNF1,CNF2,CNF).




% task 2 

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

all_diff([_],[]).

all_diff([X, Y|Ys],CNF):-
    diff(X, Y, CNF1),
    all_diff([X|Ys], CNF2),
    all_diff([Y|Ys], CNF3),   
    append([CNF1, CNF2, CNF3], CNF).

% % task 3

diff_int(X,Y) :-
    X \== Y.

all_diff_int([_]).

all_diff_int([X,Y|R]) :- 
    diff_int(X,Y),
    all_diff_int([X|R]),
    all_diff_int([Y|R]).

all_diff_kakuro([]).

all_diff_kakuro([ _ = L|T]) :-
    all_diff_int(L),
    all_diff_kakuro(T).

all_sum_kakuro([]).

all_sum_kakuro([ S = L|T]) :-
    sum_list(L,S),
    all_sum_kakuro(T).

kakuroVerify(X) :-
    all_diff_kakuro(X),
    all_sum_kakuro(X).

test_kakuroVerify() :-
    kakuroVerify([15 = [1,6,6,5]]).


% task 4


kakuroEncode(Instance,MAP,CNF) :-
    map_instance(Instance,MAP),
    create_cnf(Instance,MAP,CNF).


% mapping isntance
map_instance(I,MAP) :-
    flatten(I,[],F), % flatten vars
    list_to_set(F,Fn), % remove duplicates from flatten list of vars
    map(Fn,MAP).

flatten([],F,F).

flatten([_=I|R],F,Fn) :-
    append(I,F,Ft),
    flatten(R,Ft,Fn).

map([],[]).

map([V|Xs], [V=Vn|Ys]) :-
    length(Vn,4),
    map(Xs,Ys).

% create CNF from Instantece and Map

create_cnf([I=V],MAP,CNF) :-
    get_vars_from_map(V,MAP,[],VARS),
    sum_equals(I,VARS,CNF1),
    all_diff(VARS,CNF2),
    append(CNF1,CNF2,CNF).

create_cnf([I=V|T],MAP,CNF) :-
    get_vars_from_map(V,MAP,[],VARS),
    sum_equals(I,VARS,CNF1),
    all_diff(VARS,CNF2),
    create_cnf(T,MAP,CNF3),
    append(CNF1,CNF2,CNF3,CNF).

get_vars_from_map([],_,V,V).

get_vars_from_map([H|T],MAP,V,Vn) :-
    writeln(H),
    find_var_in_map(H,MAP,Vh),
    append(V,Vh,Vt),
    get_vars_from_map(T,MAP,Vt,Vn).

find_var_in_map(V,[Vm = Val | _],Vh) :-
    V == Vm,
    Vh = Val.

find_var_in_map(V,[Vm = _ | T],Vh) :-
    V \== Vm,
    find_var_in_map(V,T,Vh).


% task 5

kakuroDecode([V=Val|Tm],[V=Vm|Ts]) :-
    binray_to_int(0,Val,0,Vm),
    kakuroDecode(Tm,Ts).

binray_to_int(_,[],INT,INT).

binray_to_int(I,[-1|T],ACC,INT) :-
    In is I + 1,
    binray_to_int(In,T,ACC,INT).

binray_to_int(I,[1|T],ACC,INT) :-
    P is 2**I,
    ACCn is ACC + P,
    In is I + 1,
    binray_to_int(In,T,ACCn,INT).

% task 6

kakuroSolve(Instance, Solution):-
	kakuroEncode(Instance,MAP,CNF),
	sat(CNF),
	kakuroDecode(MAP,MSolution),
	kakuroSolution(Instance, MSolution, Solution),
	kakuroVerify(Solution).


kakuroSolution([], _, []).

kakuroSolution([C=V|Ri], MAP, [C=Vs|Rs]):-
	get_var_int_value(V, MAP, Vs),
	kakuroSolution(Ri, MAP, Rs).

get_var_int_value([], _, []).

get_var_int_value([V|Ri], MAP, [INT|Rs]):-
	find_var_in_map(V, MAP, INT),
	get_var_int_value(Ri, MAP, Rs).


