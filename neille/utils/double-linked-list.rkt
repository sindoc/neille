#lang racket

(require a-d/positional-list/augmented-double-linked)

(provide 
 new new* length empty? full?
 map map! map< map<! to-list
 attach-first! attach-last! attach-middle!
 detach-first! detach-last! detach-middle!)

(define 
  (generic-traversal 
   plist act 
   [init first] [step next] [until has-next?] #:mutate? [mutate? #f])
  (define result (if mutate? void (new (equality plist))))
  (do ((iter (init plist) (step plist iter)))
      ((not (until plist iter))
       (act result iter (peek plist iter)))
    (act result iter (peek plist iter)))
  (if mutate? plist result))

(define (map> plist proc)
  (generic-traversal 
   plist
   (lambda (res pos val)
     (attach-last! res (proc pos val)))))

(define (map>! plist proc)
  (generic-traversal 
   plist
   (lambda (_ pos val)
     (update! plist pos (proc pos val)))
   #:mutate? #t))

(define (map< plist proc)
  (generic-traversal 
   plist
   (lambda (res pos val)
     (attach-first! res (proc pos val)))
   last previous has-previous?))

(define (map<! plist proc)
  (generic-traversal 
   plist
   (lambda (_ pos val)
     (update! plist pos (proc pos val)))
   last previous has-previous?
   #:mutate? #t))

(define map map>)
(define map! map>!)

(define (to-list plist)
  (define result null)
  (map<!
   plist
   (lambda (pos val)
     (set! result (cons val result))
     val))
  result)

(define (new* ==? lst)
  (define dls (new ==?))
  (for-each
   (lambda (e)
     (attach-last! dls e))
   lst)
  dls)
