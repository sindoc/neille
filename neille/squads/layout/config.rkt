#lang racket



(require
 
 neille/common/model-classes
 
 neille/cards/base)



(provide 
 
 (all-defined-out))


(define units     (new cardlist-%))

(define card-list (new cardlist-%))


(define dummy-card  (car cards))

(define detail-card dummy-card)

(define hero-card   dummy-card)


(define trash          null)

(define meta-detail    null)

(define meta-hero      null)

(define meta-units     null)

(define previous-cards null)

(define next-cards     null)

(define save-squad     null)

(define (on-click) void)