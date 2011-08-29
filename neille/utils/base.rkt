#lang racket

(provide (all-defined-out))

(define (show #:sep [sep " "] . args)
  (for-each
   (lambda (arg)
     (display arg)
     (display sep))
   args)
  (newline)
  void)

(define (vector-map! vect proc)
  (define last (- (vector-length vect) 1))
  (let loop
    ((i 0))
    (vector-set! vect i (proc i (vector-ref vect i)))
    (when (< i last)
      (loop (+ i 1))))
  vect)