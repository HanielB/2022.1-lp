Control.Print.printDepth := 100;

type Num = int;
type Var = string;

datatype Aexp =
         ANum of Num
         | AVar of Var
         | Plus of Aexp * Aexp
         | Mult of Aexp * Aexp
         | Minus of Aexp * Aexp;

datatype Bexp =
         True
       | False
       | Eq of Aexp * Aexp
       | Leq of Aexp * Aexp
       | Not of Bexp
       | And of Bexp * Bexp;

datatype Stm =
         (* Assign of Var * Aexp *)
         Assign of Aexp * Aexp
       | Skip
       | Comp of Stm * Stm
       | If of Bexp * Stm * Stm
       | While of Bexp * Stm;

(*
  x := 1;
  (y := x + 5;
   (if y <= 6 then z := y else z := y * 2;
    skip)
  )
*)

val p1 = Comp(
        Assign(AVar "x", ANum 1),
        Comp(
            Assign(AVar "y", Plus(AVar "x", ANum 5)),
            Comp(
                If(Leq(AVar "y", ANum 6),
                   Assign(AVar "z", AVar "y"),
                   Assign(AVar "z", Mult(AVar "y", ANum 2))
                  ),
                Skip
            )
        )
    );

exception FreeVar
fun lookup (x : Var) [] = raise FreeVar
  | lookup x ((v, value)::l) = if x = v then value else lookup x l;

fun evalA (ANum n) s = n
  | evalA (AVar x) s = lookup x s
  | evalA (Plus(e1, e2)) s = (evalA e1 s) + (evalA e2 s)
  | evalA (Mult(e1, e2)) s = (evalA e1 s) * (evalA e2 s)
  | evalA (Minus(e1, e2)) s = (evalA e1 s) - (evalA e2 s);

val state = [("x", 6), ("y", 7), ("z", 8)];
val exp = Plus(AVar "x", AVar "w");

evalA exp state;

fun evalB True s = true
  | evalB False s = false
  | evalB (Eq(e1, e2)) s = (evalA e1 s) = (evalA e2 s)
  | evalB (Leq(e1, e2)) s = (evalA e1 s) <= (evalA e2 s)
  | evalB (Not(e)) s = not (evalB e s)
  | evalB (And(e1, e2)) s = (evalB e1 s) andalso (evalB e2 s);


fun evalStm (Assign(AVar x, a)) s = (x, evalA a s)::s
  | evalStm Skip s = s
  | evalStm (Comp(stm1, stm2)) s = evalStm stm2 (evalStm stm1 s)
  | evalStm (If(b, stm1, stm2)) s = if (evalB b s) then
                                        evalStm stm1 s
                                    else
                                        evalStm stm2 s
  | evalStm _ _ = raise Match;

(*
  x := 1;
  y := x + 5;
  if y <= 6 then z := y else z := y * 2;
  print(y)
*)
p1;
evalStm p1 [];

(*
  x := 1;
  x := 0;
  y := x + 5;
  if y <= 6 then z := y else z := y * 2;
  print(y)
*)
val p2 = Comp(
        Assign(AVar "x", ANum 1),
        Comp(
            Assign(AVar "x", ANum 0),
            Comp(
                Assign(AVar "y", Plus(AVar "x", ANum 5)),
                Comp(
                    If(Leq(AVar "y", ANum 6),
                       Assign(AVar "z", AVar "y"),
                       Assign(AVar "z", Mult(AVar "y", ANum 2))
                      ),
                    Skip
                )
            )
    ));

evalStm p2 [];
