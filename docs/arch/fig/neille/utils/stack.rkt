#lang racket

(require a-d/stack/amortized)

(provide 
 new* new stack? push! pop! top empty? full?
 to-list)

(define (traverse stack proc)
  (define inverse-clone (new))
  (define (action x)
    (push! inverse-clone x)
    (proc x))
  (define (reverse-action x)
    (push! stack x))
  (unless (empty? stack)
    (do ((current (pop! stack) (pop! stack)))
	((empty? stack) (action current))
      (action current))
    (do ((current (pop! inverse-clone) (pop! inverse-clone)))
	((empty? inverse-clone) (reverse-action current))
      (reverse-action current)))
  stack)

(define (new* lst)
  (define stack (new))
  (for-each
   (lambda (e)
     (push! stack e))
   lst)
  stack)

(define (to-list stack)
  (define result null)
  (unless (empty? stack)
    (traverse stack (lambda (x) (set! result (cons x result)))))
  result)