(use-modules (ice-9 regex)
	     (ice-9 match)
	     (util))

(define bot-gives-regexp
  (make-regexp
   "bot ([0-9]+) gives low to (bot|output) ([0-9]+) and high to (bot|output) ([0-9]+)"))

(define value-goes-regexp
  (make-regexp
   "value ([0-9]+) goes to bot ([0-9]+)"))


(define (b/o s) (if (string= s "bot") #:bot #:output))
(define ms match:substring)
(define s2n string->number)

(define (parse-instruction str)
  (let ((bm (regexp-exec bot-gives-regexp str))
	(vm (regexp-exec value-goes-regexp str)))
    (cond (bm
	   (let ((bot-id (s2n (ms bm 1)))
		 (low-output (cons (b/o (ms bm 2)) (s2n (ms bm 3))))
		 (high-output (cons (b/o (ms bm 4)) (s2n (ms bm 5)))))
	     (list bot-id low-output high-output)))
	  (vm (list (s2n (ms vm 1))
		    (s2n (ms vm 2)))))))

(define (initialize is) ;; set initial values to bots
  (let ((h (make-hash-table))
	(r (make-hash-table)))
    ;; XXX: iterate over is and set the initial values in h
    (map (lambda (i)
	   (match i
	     ((val id)
	      (if (hash-ref h id)
		  (hash-set! h id (cons val (hash-ref h id)))
		  (hash-set! h id (list val))))
	     ((id low high)
	      (if (hash-ref r id)
		  (error "repeat instruction")
		  (hash-set! r id (cons low high))))
	     (else (error "Unknown instruction"))))
	 is)
    (list r h (make-hash-table)))) ;; rules state output

(define (eval-rule! rule state output val)
  (let ((table (if (eq? (car rule) #:output) output state)))
    (hash-set! table (cdr rule)
	       (cons val (hash-ref table (cdr rule) '())))))

(define (iterate rules state output)
  (let ((count 0))
    (hash-for-each
     (lambda (id contents)
       (when (or (equal? contents '(61 17))
	       (equal? contents '(17 61)))
	 (display id) (newline)) ;; print the bot comparing 61 and 17
       (if (= (length contents) 2)
	   (let ((a (car contents))
		 (b (cadr contents))
		 (r (hash-ref rules id)))
	     (if (< a b)
		 (begin (eval-rule! (car r) state output a) ;; low 
			(eval-rule! (cdr r) state output b));; high
		 (begin (eval-rule! (car r) state output b) ;; low
			(eval-rule! (cdr r) state output a))) ;;high
	     (hash-set! state id '())
	     (set! count (+ count 1)))))
     state)
    count))

(define (main file)
  (let ((s (initialize
	    (map parse-instruction (read-lines file)))))
    ;; iterate until it cannot be done
    (do ((count (apply iterate s) (apply iterate s)))
	((= count 0) s)
      '())
    (let ((o (caddr s)))
      (apply * (map car (list (hash-ref o 0)
			      (hash-ref o 1)
			      (hash-ref o 2)))))))
