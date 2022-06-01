signature SET =
sig
  type set
  val new : set
  val add : set -> int -> set
  val contains : set -> int -> bool
  val remove : set -> int -> set
end ;

structure FunSet :> SET =
struct
  type set = int -> bool
  val new = fn x => false
  fun add s i = fn (x : int) => if x = i then true else s x
  fun contains s i = s i
  fun remove s i = fn (x : int) => if x = i then false else s x
end;

structure S = FunSet ;
val s = S.new ;
val s = S.add s 3 ;
val contains1 = S.contains s 1 ;
val contains3 = S.contains s 3 ;
val s = S.remove s 3 ;
val contains3 = S.contains s 3 ;

(* transparent sealing *)

structure FunSet : SET =
struct
  type set = int -> bool
  val new = fn x => false
  fun add s i = fn (x : int) => if x = i then true else s x
  fun contains s i = s i
  fun remove s i = fn (x : int) => if x = i then false else s x
end;

structure S = FunSet ;
val s = S.new ;
val s = S.add s 3 ;
val contains1 = S.contains s 1 ;
val contains3 = S.contains s 3 ;
val s = S.remove s 3 ;
val contains3 = S.contains s 3 ;
val s1 = fn x => if x = 2 then true else false;
S.contains s1 2;
