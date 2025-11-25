%     PLEASE
% +    SOLVE
% +   PUZZLE
% =   QQQQQQ

set of int: CODEX = {0,1,2,3,5,6,8,9};

var CODEX: P;
var CODEX: L;
var CODEX: E;
var CODEX: A;
var CODEX: S;
var CODEX: O;
var CODEX: V;
var CODEX: U;

int: Z = 7;
int: Q = 7;

include "alldifferent.mzn";
constraint all_different([P,L,E,A,S,O,V,U]);
constraint P != 0;
constraint S != 0;

constraint 
              100000*P + 10000*L + 1000*E + 100*A + 10*S + E
                      +  10000*S + 1000*O + 100*L + 10*V + E
            + 100000*P + 10000*U + 1000*Z + 100*Z + 10*L + E
            = 100000*Q + 10000*Q + 1000*Q + 100*Q + 10*Q + Q;