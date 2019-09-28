#lang web-server/insta

(define (start request)
  (show-fizzbuzz 1 request))

(define (show-fizzbuzz n request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "Fizzbuzz"))
            (body
             (a ((href ,(embed/url next-fizzbuzz-handler))
                 (rel "next")
                 (data-num ,(number->string n)))
                ,(fizzbuzz n))))))

  (define (next-fizzbuzz-handler request)
    (show-fizzbuzz (+ n 1) request))

  (send/suspend/dispatch response-generator))

(define (fizzbuzz n)
  (cond
    [(divisible? n 15) "Fizzbuzz"]
    [(divisible? n 5) "Buzz"]
    [(divisible? n 3) "Fizz"]
    [else (number->string n)]))

(define (divisible? a b)
  (zero? (remainder a b)))