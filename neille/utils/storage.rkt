#lang racket



(require 
 
 neille/common/serialize
 
 racket/fasl)



(provide marshal unmarshal)



(define (marshal object)
  
  
  (define storage-file
    
    (open-output-file 
     
     storage-file-path
     
     #:mode 'binary 
     
     #:exists 'replace))
  
  
  (s-exp->fasl 
   
   (serialize object)
   
   storage-file)
  
  
  (close-output-port storage-file)
  
  
  void)



(define (unmarshal)
  
  (define storage-file 
    
    (open-input-file storage-file-path))
  
  (deserialize 
   
   (fasl->s-exp 
    
    storage-file)))



















