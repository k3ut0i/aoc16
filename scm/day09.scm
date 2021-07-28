(use-modules (ice-9 regex)
	     (ice-9 rdelim))
;; (define (parse-nat cs acc)
;;   (let ((acc->nat (lambda (a)
;; 		    (string->number (list->string (reverse a))))))
;;     (cond ((null? cs) (list (acc->nat acc)))
;; 	  ((char-set-contains? char-set:digit (car cs))
;; 	   (parse-nat (cdr cs) (cons (car cs) acc)))
;; 	  (else (cons (acc->nat acc) cs)))))
(define marker-regexp (make-regexp "\\(([0-9]+)x([0-9]+)\\)"))

(define (match->marker m)
  (cons (string->number (match:substring m 1))
	(string->number (match:substring m 2))))

(define (iterate-and-count/gen str handler)
  (let loop ((i 0)
	     (count (string-length str)))
    (let ((m (regexp-exec marker-regexp str i)))
      (if m
	  (let* ((handler-result (handler m str))
		 (skip-to (car handler-result))
		 (new-count (+ count (cdr handler-result))))
	    (loop skip-to new-count))
	  count))))

(define (iterate-and-count/inert str)
  (iterate-and-count/gen
   str
   (lambda (m s)
     (let* ((marker-len (string-length (match:substring m 0)))
	    (marker (match->marker m))
	    (len (car marker))
	    (mult (cdr marker)))
       (cons (+ (match:end m) len)
	     (+ (* (- mult 1) len) (- marker-len)))))))

(define (iterate-and-count/explosive str)
  (iterate-and-count/gen
   str
   (lambda (m s)
     (let* ((marker-len (string-length (match:substring m 0)))
 	    (marker (match->marker m))
	    (len (car marker))
	    (mult (cdr marker))
	    (next-str (substring s (match:end m)
				 (+ (match:end m) len))))
       (cons (+ (match:end m) len)
	     (+ (* mult (iterate-and-count/explosive next-str))
		(- (+ marker-len len))))))))

;; I could have combined both inert and explosive variants but
;; it would be too hairy

(define (main file)
  (let* ((port (open-file file "r"))
	 (s (read-delimited "\n" port)))
    (close port)
    (values (iterate-and-count/inert s)
	    (iterate-and-count/explosive s))))
