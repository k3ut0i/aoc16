(use-modules (srfi srfi-1)
	     (ice-9 rdelim)
	     (aoc16 util))

(define (update-counts s counts)
  (let ((f (lambda (c ct)
	     (if (assq c ct)
		 (assq-set! ct c (+ 1 (cdr (assq c ct))))
		 (acons c 1 ct)))))
    (map f (string->list s) counts)))

(define (max-key alist order)
  (reduce (lambda (e1 e2)
	    (if (order (cdr e1) (cdr e2)) e1 e2))
	  (cons #:null 0)
	  alist))

(define (most-and-least-common-chars strs)
  (let ((all-counts
	 (fold update-counts
	       (make-list (string-length (car strs)) '())
	       strs)))
    (cons (list->string (map (lambda (a) (car (max-key a >))) all-counts))
	  (list->string (map (lambda (a) (car (max-key a <))) all-counts)))))

(define (main file)
  (most-and-least-common-chars (read-lines file)))
