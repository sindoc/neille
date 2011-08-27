#lang racket

(require
 neille/cards/base)

(provide (all-defined-out))

(define detail-card
  (car cards))

(define hero-card
  (cadr cards))

(define meta-detail null)
(define meta-hero null)
(define meta-units null)
(define previous-heroes null)
(define next-heroes null)
(define previous-units null)
(define next-units null)