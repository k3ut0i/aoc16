(use-modules (ice-9 popen)
	     (ice-9 rdelim))

;; Load the external md5 implementation
(eval-when (load eval compile)
  (load-extension "./libmd5_hex.so" "init_md5_hex"))
(define (acceptable str)
  (string= str "00000" 0 5))

;; differing to external process XXX: Too slow
(define (md5sum-ext s)
  (let* ((port (open-input-pipe (string-append "echo -n '"
						s
						"'|md5sum")))
	  (line (read-line port)))
    (close-pipe port)
    (substring line 0 32)))

(define md5sum md5_hex) ;; rename the c-exported one

(define (find-pass-1 door-id)
  (let loop ((i 0)
	     (chars '()))
    (let ((s (md5sum (string-append door-id
					(number->string i)))))
      (if (acceptable s)
	  (let ((c (string-ref s 5)))
	    ;; (display c) ;; show the character as it is discovered
	    (if (= (length chars) 7)
		(list->string (reverse (cons c chars)))
		(loop (+ i 1) (cons c chars))))
	  (loop (+ i 1) chars)))))
;; part1
;; (find-pass-1 "ugkcyxxp")

(define (acceptable-2 s)
  (and (acceptable s)
       (char<=? #\0 (string-ref s 5))
       (char<=? (string-ref s 5) #\7)))

(define (coalesce pv)
  (do ((x pv (cdr x))
       (s (make-vector (length pv))))
      ((null? x) (list->string (vector->list s)))
    (vector-set! s (car (car x)) (cdr (car x)))))

(define (assoc-cons-if-null key val alist)
  (if (assq key alist)
      alist
      (acons key val alist)))

(define (find-pass-2 door-id)
  (let loop ((i 0)
	     (chars '())) ;; TODO: Change to vector so we can exclude repeated positions
    (let ((s (md5sum (string-append door-id
				    (number->string i)))))
      (if (acceptable-2 s)
	  (let* ((pos (- (char->integer (string-ref s 5)) 48))
		 (c (string-ref s 6))
		 (new-chars (assoc-cons-if-null pos c chars)))
	    ;;	    (display new-chars) (newline)
	    (if (=  (length new-chars) 8)
		(coalesce new-chars)
		(loop (+ i 1) new-chars)))
	  (loop (+ i 1) chars)))))
;; part2
;; (find-pass-2 "ugkcyxxp")
