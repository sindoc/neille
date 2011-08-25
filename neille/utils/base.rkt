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