#lang racket



(require
 
 neille/utils/storage
 
 neille/battle/common
 
 neille/players/base
 
 neille/battle/engine)



(start-playing)



(marshal human)

(define mirror (unmarshal))