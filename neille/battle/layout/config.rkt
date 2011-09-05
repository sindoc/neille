#lang racket


;; This module must export bindings with the same name
;; as the parameters defined in layout.xml


(require 
 
 neille/players/base
 
 neille/common/view-classes/base
 
 neille/battle/model)

 

(provide
 
 human
 
 robot
 
 (all-defined-out)
 
 (all-from-out
  
  neille/battle/model))


  
(define morale-callback 
  
  (send 
   
   (new morale-view% (model human))
   
   get-paint-callback))














