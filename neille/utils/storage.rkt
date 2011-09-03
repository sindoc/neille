#lang racket

(require 
 neille/players/base
 neille/common/model-classes
 neille/cards/base
 neille/squads/static
 neille/common/syntax
 neille/utils/serialize
 racket/fasl)

(provide marshal unmarshal)

(define (marshal object)
  (define storage-file
    (open-output-file 
     storage-file-path
     #:mode 'binary 
     #:exists 'replace))
  
  (s-exp->fasl 
   (send object externalize) storage-file)
  
  (close-output-port storage-file)
  void)

(define (unmarshal player)
  (define storage-file 
    (open-input-file storage-file-path))
  (fasl->s-exp storage-file))

(define (init)
  (send+ human 'add-delegate 'squads squads))

(init)
(marshal human)
