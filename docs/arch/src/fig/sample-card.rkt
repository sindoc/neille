#lang racket

(define-struct ws-card 
  (id name type squadrole faction specials note ready health attack 
      units artifacts spells image) #:transparent #:mutable)

(define-struct ws-card-graphic 
  (type basename path-prefix path-suffix scales) #:transparent #:mutable)

...

(register-card 
 #:id 'T4-Loremaster-Tani 
 #:ready 8 
 #:health 6 
 #:attack 1 
 #:units 3 
 #:artifacts 1 
 #:spells 2 
 #:name "Loremaster Tani" 
 #:type 'Hero 
 #:squadrole 'Hero 
 #:faction 'Elf 
 #:specials (list "Zap" "Zap" ) 
 #:note (list "Twice each action, deals 1 damage to a random enemy" ) 
 #:image 
 (make-ws-card-graphic 
  'jpeg "WS-Hero-Elf-Loremaster-Tani" "cards/img/" ".jpg" null))

...