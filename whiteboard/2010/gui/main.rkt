#lang racket/gui

(define (layout)
  (define self '())
  (define ui '())
  (define name "Neille")
  (define min-width 1024)
  (define min-height 768)
  (define (init)
    (set! 
     ui 
     (new 
      frame% 
      [label name]
      [width min-width]
      [height min-height]))
    (set! self dispatch-layout)
    (init-components)
    (send ui show #t)
    (sleep/yield 1)
    self)
  (define (init-components)
    (define menu-bar (make-menu-bar self))
    (define file-menu (make-file-menu menu-bar))
    (define quit-menu-item (make-quit-menu-item file-menu))
    'OK
    )
    
  (define (dispatch-layout msg)
    (case msg
      ((layout?) #t)
      ((name) name)
      ((min-width) min-width)
      ((min-height) min-height)
      ((root-container) self)
      ((ui) ui)
      (else
       (error "Unknown message" msg))))
  (init))

(define (make-field container)
  (define self '())
  (define ui '())
  (define (init)
    (unless (container 'layout?)
      (error "Parent must be of type Layout" container))
    (set! 
     ui
     (new 
      panel% 
      [parent (container 'ui)]))
    (set! self dispatch-field)
    self)
  (define (dispatch-field msg)
    (case msg
      ((field?) #t)
      ((container) container)
      (else
       (error "Unknown message" msg))))
  (init))

(define (make-menu-bar container)
  (define self '())
  (define ui '())
  (define (init)
    (unless (container 'layout?)
      (error "Wrong container type") container)
    (set!
     ui
     (new 
      menu-bar%
      [parent (container 'ui)]))
    (set! self dispatch-menu-bar)
    self)
  (define (dispatch-menu-bar msg)
    (case msg
      ((menu-bar?) #t)
      ((ui) ui)
      ((container) container)
      ((root-container) (container msg))
      (else
       (error "Unknown message" msg))))
  (init))

(define (make-menu name container)
  (define self '())
  (define ui '())
  (define (init)
    (set!
     ui
     (new
      menu%
      [label name]
      [parent (container 'ui)]))
    (set! self dispatch-menu)
    self)
  (define (dispatch-menu msg)
    (case msg
      ((menu?) #t)
      ((ui) ui)
      ((container) container)
      ((root-container) (container msg))
      (else
       (error "Unknown message" msg))))
  (init))

(define (make-menu-item name callback container)
  (define self '())
  (define ui '())
  (define (init)
    (set!
     ui
     (new
      menu-item%
      [label name]
      [callback callback]
      [parent (container 'ui)]))
    (set! self dispatch-menu-item)
    self)
  (define (dispatch-menu-item msg)
    (case msg
      ((menu-item?) #t)
      ((ui) ui)
      ((container) container)
      (else
       (error "Unknown message" msg))))
  (init))

(define (make-file-menu container)
  (define self '())
  (define usual '())
  (define (init)
    (set! usual (make-menu "File" container))
    (set! self dispatch-file-menu)
    self)
  (define (dispatch-file-menu msg)
    (case msg
      ((file-menu?) #t)
      (else
       (usual msg))))
  (init))

(define (make-quit-menu-item container)
  (define self '())
  (define usual '())
  (define (callback i e)
    (send ((container 'root-container) 'ui) show #f))  
  (define (init)
    (set! usual (make-menu-item "Quit" callback container))
    (set! self dispatch-quit-menu-item)
    self)
  (define (dispatch-quit-menu-item msg)
    (case msg
      ((quit-menu-item?) #t)
      (else
       (usual msg))))
  (init))

;; Will port these later
;(define graveyard
;  (new 
;   panel% 
;   [parent field]))
;
;(define graveyard-canvas
;  (new 
;   canvas%
;   [parent graveyard]
;   [min-width 500] 
;   [min-height 500]))
;
;(define graveyard-canvas-dc
;  (send graveyard-canvas get-dc))
;
;(define card
;  (make-object bitmap% 
;    "img/WS-Unit-Elf-Shadow-Panther.jpg"))
;
;(define (init-graveyard)
;  (send graveyard-canvas-dc
;        draw-bitmap card 10 10))
