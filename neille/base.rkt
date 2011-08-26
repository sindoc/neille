#lang racket

(require 
 neille/model
 racket/mpair
 (prefix-in ring: a-d/ring))

(provide (all-defined-out))

(define human (new player% (name 'human)))
(define robot (new player% (name 'robot)))

(define players (list human robot))
(define player-ring 
  (ring:from-scheme-list (list->mlist players)))