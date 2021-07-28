(use-modules (aoc16 util)
	     (srfi srfi-1) ;; filter-map, count
	     (ice-9 receive) ;; receive
	     (ice-9 match) ;; match
	     (ice-9 regex)) ;; string-match
;; XXX: I should have used some pattern matching here. look at aba?
(define (abba-c? chars)
  (cond ((or (null? chars)
	     (null? (cdr chars))
	     (null? (cddr chars))
	     (null? (cdddr chars)))
	 #f)
	((and (char=? (car chars) (cadddr chars))
	      (char=? (cadr chars) (caddr chars))
	      (not (char=? (car chars) (cadr chars))))
	 #t)
	(else (abba-c? (cdr chars)))))

(define (abba? s)
  (abba-c? (string->list s)))


;; Why doesnt' guile have destructuring bind?
;; Hmm, there are let-values in srfi, and match in ice-9
(define (tls? ipv7-str)
  (receive (super hyper)
      (unsplice (string-split ipv7-str (char-set #\[ #\])))
    (and (any abba? super)
	 (every (lambda (s) (not (abba? s))) hyper))))

(define (aba-c cs) ;; return bab if exists else #f
  (match cs
    ((a b c . rest) (if (and (char=? a c) (not (char=? a b)))
			(cons (list->string (list b a b))
			      (aba-c (cdr cs)))
			(aba-c (cdr cs))))
    (else '())))

(define (aba ss)
  (apply append (filter-map (lambda (s) (aba-c (string->list s))) ss)))

(define (ssl? ipv7-str)
  (receive (super hyper)
      (unsplice (string-split ipv7-str (char-set #\[ #\])))
    (any (lambda (bab)
	   (any (lambda (s) (string-match bab s)) hyper))
	 (aba super))))

(define (main file)
  (let ((lines (read-lines file)))
    (values (count tls? lines)
	    (count ssl? lines))))
