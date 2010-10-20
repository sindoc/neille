#lang racket/gui

(define *layout-name* "Neille")

(define layout
  (new frame% 
       [label *layout-name*]
       [width 1024]
       [height 768]))

(define field
  (new 
   panel% 
   [parent layout]))

(define graveyard
  (new 
   panel% 
   [parent field]))

(define graveyard-canvas
  (new 
   canvas%
   [parent graveyard]
   [min-width 500] 
   [min-height 500]))

(define graveyard-canvas-dc
  (send graveyard-canvas get-dc))

(define card
  (make-object bitmap% 
    "/home/yaz/neille/img/WS-Unit-Elf-Shadow-Panther.jpg"))

(define (init-graveyard)
  (send graveyard-canvas-dc
        draw-bitmap card 10 10))

(define main-menu-bar
  (new menu-bar% [parent layout]))

(define file-menu
  (new menu% 
       [label "File"]
       [parent main-menu-bar]))

(define (on-quit i e)
  (send layout show #f))

(define quit-menu-item
  (new menu-item%
       [label "Quit"]
       [parent file-menu]
       [callback on-quit]))

(define (init)
  (init-graveyard))

(send layout show #t)
(sleep/yield 1)
(init)
