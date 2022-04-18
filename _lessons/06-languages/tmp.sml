datatype bexpr = BConst of bool | Not of bexpr | And of bexpr * bexpr | Or of bexpr * bexpr;


datatype aexpr =
         IConst of int
         | Plus of aexpr * aexpr
         | Minus of aexpr * aexpr
         | Ite of bexpr * aexpr * aexpr
         | Var of string;


fun evalb (BConst b) = b
  | evalb (Not b) = not (evalb b)
  | evalb (And(b1, b2)) = (evalb b1) andalso (evalb b2)
  | evalb (Or(b1, b2)) = (evalb b1) orelse (evalb b2);

fun evala (IConst i) = i
  | evala (Plus(e1, e2)) = (evala e1) + (evala e2)
  | evala (Minus(e1, e2)) = (evala e1) - (evala e2)
  | evala (Ite(c, t, e)) =  if (evalb c) then (evala t) else (evala e);

val state = [("x", 3), ("y", 78), ("z", 676)];

fun lookup [] id = raise Match
  | lookup ((k:string, v)::t) id = if k = id then v else lookup t id;

lookup state "x";

fun eval (IConst i) _ = i
  | eval (Var x) state = lookup state x
  | eval (Plus(e1, e2)) state = (eval e1 state) + (eval e2 state)
  | eval (Minus(e1, e2)) state = (eval e1 state) - (eval e2 state)
  | eval (Ite(c, t, e)) state = if (evalb c) then (eval t state) else (eval e state);

eval;
eval (Plus(Var "x", IConst 5)) state;


val y = 1;

fun f1 x = x + y;
fun f2 z = z + y;
fun f3 y = y + y;
