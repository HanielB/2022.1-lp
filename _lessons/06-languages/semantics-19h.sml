Control.Print.printDepth := 100;

(*
  x := 1;
  y := x + 5;
  if y <= 6 then z := y else z := y * 2;
  skip
*)

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
         Assign of Aexp * Aexp
       | Skip
       | Comp of Stm * Stm
       | If of Bexp * Stm * Stm
       | While of Bexp * Stm;

val p1 = Comp(
        Assign(AVar "x", ANum 1),
        Comp(
            Assign(AVar "y", Plus(AVar "x", ANum 5)),
            Comp(If(
                      Leq(AVar "y", ANum 6),
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

fun evalB True s = true
  | evalB False s = false
  | evalB (Eq(e1, e2)) s = (evalA e1 s) = (evalA e2 s)
  | evalB (Leq(e1, e2)) s = (evalA e1 s) <= (evalA e2 s)
  | evalB (Not(b)) s = not (evalB b s)
  | evalB (And(b1, b2)) s = (evalB b1 s) andalso (evalB b2 s);

fun evalStm (Assign(AVar x, a)) s = (x, evalA a s)::s
  | evalStm Skip s = s
  | evalStm (Comp(stm1, stm2)) s = let val s' = (evalStm stm1 s) in
                                       evalStm stm2 s'
                                   end
  | evalStm (If(b, stm1, stm2)) s = if evalB b s then
                                        evalStm stm1 s
                                    else
                                        evalStm stm2 s
  | evalStm _ _ = raise Match;

evalStm p1 [];
