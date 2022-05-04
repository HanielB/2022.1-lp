(set-logic QF_UFLIA)

(declare-const c Bool)
(declare-const e1 Int)
(declare-const e2 Int)

(define-fun p0 () Int (ite c e1 e2))
(define-fun p1 () Int (ite (not c) e2 e1))

(assert (not (= p0 p1)))

(check-sat)
