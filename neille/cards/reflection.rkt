#lang racket



(provide
 
 (all-defined-out))



(define card-clone-maker-delegate       'make-clone)

(define card-view-maker-delegate        'make-view)

(define card-detail-view-maker-delegate 'make-detail-view)



(define card-view-delegate              'view)

(define card-detail-view-delegate       'detail-view)



(define card-ws-card-delegate           'ws-card)



(define card-abilities-delegate        'abilities)