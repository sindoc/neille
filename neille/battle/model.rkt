#lang racket


(require
 
 neille/common/model-classes)



(provide 
 
 (all-defined-out))



(define ready-counter   (new cardlist%))

(define deck            (new deck%))

(define staging         (new cardlist%))

(define reserve         (new deck%))

(define inplay          (new cardlist%))

(define graveyard       (new deck%))

(define -reserve        (new deck%))

(define -inplay         (new cardlist%))

(define -graveyard      (new deck%))

(define -deck           (new deck%))

(define -staging        (new cardlist%))

(define -ready-counter  (new cardlist%))