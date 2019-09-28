#lang web-server/insta

;; A "hello world" web server
(define (start request)
  (response/xexpr
   '(html
     (head (title "Racket"))
     (body "Hello World"))))