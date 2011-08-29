#lang racket

(require
 neille/cards/base)

(provide (all-defined-out))

(define dummy-card (car cards))
(define detail-card dummy-card)
(define hero-card dummy-card)

(define trash null)
(define meta-detail null)
(define meta-hero null)
(define meta-units null)
(define previous-cards null)
(define next-cards null)

(define (on-click) void)