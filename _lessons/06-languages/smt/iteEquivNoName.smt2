(set-logic QF_UFLIA)

(declare-const c Bool)
(declare-const e1 Int)
(declare-const e2 Int)

(assert (not (= (ite c e1 e2) (ite (not c) e2 e1))))

(check-sat)
