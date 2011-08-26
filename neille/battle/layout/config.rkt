#lang racket

;; This module must export bindings with the same name
;; as the parameters defined in layout.xml

(require 
 neille/view
 neille/base)

(provide human robot morale-callback)

(define morale-callback 
  (send 
   (new morale-view% (model human)) 
   get-paint-callback))