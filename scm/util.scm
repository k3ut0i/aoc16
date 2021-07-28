(define-module (aoc16 util)
  #:export (read-lines
	    unsplice))

(use-modules (ice-9 rdelim))

(define (read-lines file)
  (call-with-input-file file
    (lambda (port)
      (let loop ((lines '()))
	(let ((line (read-line port)))
	  (if (eof-object? line)
	      (reverse lines)
	      (loop (cons line lines))))))))

(define (unsplice lst)
  (let loop ((a '())
	     (b '())
	     (l lst))
    (cond ((null? l) (values (reverse a) (reverse b)))
	  ((null? (cdr l)) (values (reverse (cons (car l) a)) (reverse b)))
	  (else (loop (cons (car l) a) (cons (cadr l) b) (cddr l))))))
