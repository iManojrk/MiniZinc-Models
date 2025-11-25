
var bool: opt_neq_ap;
var bool: opt_neq_aa;
var bool: opt_neq_pp;

var bool: neq_ap;
var bool: neq_aa;
var bool: neq_pp;

constraint(opt_neq_ap = (<> ~!= 55));
constraint(opt_neq_aa = (<> ~!= <>));
constraint(opt_neq_pp = (33 ~!= 55));
constraint(neq_ap = (<> != 55));
constraint(neq_aa = (<> != <>));
constraint(neq_pp = (33 != 55));

var bool: opt_eq_ap;
var bool: opt_eq_aa;
var bool: opt_eq_pp;

var bool: eq_ap;
var bool: eq_aa;
var bool: eq_pp;

constraint(opt_eq_ap = (<> ~= 55));
constraint(opt_eq_aa = (<> ~= <>));
constraint(opt_eq_pp = (33 ~= 55));
constraint(eq_ap = (<> = 55));
constraint(eq_aa = (<> = <>));
constraint(eq_pp = (33 = 55));

type TT = tuple(opt int, opt int);

var TT: opt_tuple;
constraint( opt_tuple = (<>, <>));

type Position_opt = record(opt 1..5: r, opt 1..5: c);
type Position = record(1..5: r, 1..5: c);

% var pos