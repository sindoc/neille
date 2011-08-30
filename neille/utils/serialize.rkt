#lang racket

(provide (all-defined-out))

(define storage-file-path "neille-storage")

(define-struct ws-player
  (name squads)
  #:prefab)

(define-struct ws-squad
  (hero units)
  #:prefab)

(define (serialize- any)
  (send any externalize))