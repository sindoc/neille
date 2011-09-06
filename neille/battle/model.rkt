#lang racket


(require
 
 neille/battle/model-classes/base
 
 neille/common/model-classes/base)



(provide 
 
 (all-defined-out))



(define ready-counter   (new cardlist%))

(define deck            (new deck%))

(define staging         (new cardlist%))

(define reserve         (new deck%))

(define inplay          (new inplay%))

(define graveyard       (new deck%))

(define -reserve        (new deck%))

(define -inplay         (new inplay%))

(define -graveyard      (new deck%))

(define -deck           (new deck%))

(define -staging        (new cardlist%))

(define -ready-counter  (new cardlist%))
