from cvc5.pythonic import *

if __name__ == '__main__':

    # We want to show the equivalence of the programs
    #
    # ITE(c, e1, e2) and ITE(not(c), e2, e1)
    #
    # Let's first introduce some variables so that we can build these programs.
    #
    # We have a *Boolean* variable for the
    # condition of the ITE:
    c = Bool('c')
    # We have two integer variables for the possible results of the ITE
    e1, e2 = Ints('e1 e2')
    # Finally we build the two programs. For this we will use the primitive
    # operators "If" and "Not" from the language of the SMT solver. Their
    # semantics correspond exactly to the formal semantic of these operators in
    # our expression language.
    p0 = If(c, e1, e2)
    p1 = If(Not(c), e2, e1)
    # Are these two programs equivalent? This is the case if they are equal for
    # every possible value of c, e1, and e2. Analagously, this is the case if
    # there is *no* value of c, e1 and e2 so that they are *different*. We
    # phrase the problem like this because in SMT we ask the question of
    # whether a formula can be made true ("satisfiable") or if that's
    # impossible ("unsatisfiable"). If it is unsatisfiable that the two
    # programs are different, they they are equivalent.
    solve(p0 != p1)
