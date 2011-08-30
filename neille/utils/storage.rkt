#lang racket

(require 
 neille/model
 neille/cards/base
 neille/base
 neille/utils/syntax
 neille/utils/serialize
 racket/fasl)

(provide marshal unmarshal)

(define (marshal object)
  (define storage-file
    (open-output-file 
     storage-file-path
     #:mode 'binary 
     #:exists 'replace))
  
  (s-exp->fasl 
   (send object externalize) storage-file)
  
  (close-output-port storage-file)
  void)

(define (unmarshal player)
  (define storage-file 
    (open-input-file storage-file-path))
  (fasl->s-exp storage-file))


;; Minor testing
(define (make-squad* m)
  (define (mk-card stem)
    (define clone ((send+ stem 'make-clone)))
    ((send+ clone 'make-view) clone)
    clone)
  (define squad
    (cons 
     (mk-card (car (filter hero? cards)))
     (map (lambda (c) (mk-card c)) (take cards (* m 6)))))
  (list (new squad% (hero (car squad)) (squad squad))))

(define squads (make-squad* 1))

(define (init)
  (send+ human 'add-delegate 'squads squads))

(init)
(marshal human)