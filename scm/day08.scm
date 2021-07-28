(use-modules (aoc16 util))

(define (parse-instruction s) ;; What a mess. Should have used regex
  (let ((ws (string-split s (char-set #\space))))
    (cond
     ((string= "rect" (car ws)) (cons 'rect
				      (map string->number
					   (string-split (cadr ws) #\x))))
     ((string= "rotate" (car ws))
      (cond
       ((string= "row" (cadr ws))
	(list 'row
	      (string->number (cadr (string-split (caddr ws) #\=)))
	      (string->number (car (cddddr ws)))))
       ((string= "column" (cadr ws))
	(list 'column
	      (string->number (cadr (string-split (caddr ws) #\=)))
	      (string->number (car (cddddr ws)))))
       (else (error "unknown rotation"))))
     (else (error "unknown instruction")))))

(define (rect-turn-on! s cols rows)
  (do ((y 0 (+ y 1)))
      ((= y rows) s)
    (do ((x 0 (+ x 1)))
	((= x cols))
      (array-set! s #t x y))))

(define (print-display s)
  (let ((cols (car (array-dimensions s)))
	(rows (cadr (array-dimensions s)))
	(count 0))
    (do ((y 0 (+ y 1)))
	((= y rows) count)
      (do ((x 0 (+ x 1)))
	  ((= x cols))
	(set! count (+ count (if (array-ref s x y) 1 0)))
	(display (if (array-ref s x y) #\# #\.)))
      (newline))))

(define (rotate-row! s row-num by)
  (let* ((cols (car (array-dimensions s)))
	 (rows (cadr (array-dimensions s)))
	 (new-row (make-vector cols #f)))
    (do ((x 0 (+ x 1)))
	((= x cols))
      (vector-set! new-row x (array-ref s
					(modulo (- x by) cols)
					row-num)))
    (do ((x 0 (+ x 1)))
	((= x cols))
      (array-set! s (vector-ref new-row x) x row-num))))

(define (rotate-column! s col-num by)
  (let* ((cols (car (array-dimensions s)))
	 (rows (cadr (array-dimensions s)))
	 (new-col (make-vector rows #f)))
    (do ((x 0 (+ x 1)))
	((= x rows))
      (vector-set! new-col x (array-ref s
					col-num
					(modulo (- x by) rows))))
    (do ((x 0 (+ x 1)))
	((= x rows))
      (array-set! s (vector-ref new-col x) col-num x))))

(define (execute-instruction! i s)
  (case (car i)
    ((rect) (apply rect-turn-on! (cons s (cdr i))))
    ((row) (apply rotate-row! (cons s (cdr i))))
    ((column) (apply rotate-column! (cons s (cdr i))))))

(define (execute-all is s)
  (map (lambda (str)
	      (execute-instruction! (parse-instruction str) s))
       is)
  s)

(define (main file)
  (let ((s (execute-all (read-lines file) (make-array #f 50 6))))
    (print-display s)))
