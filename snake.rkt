#lang racket

(require threading)
(require 2htdp/image)
(require 2htdp/universe)

(define scn (empty-scene 1200 800 "pink"))
(define over (empty-scene 1200 800 "red"))
(define seg (square 10 "solid" "blue"))
(define food (square 10 "solid" "yellow"))

; Render a game
; Game has worm
; - head (position)
; - tail (position)
; - direction (up, down, left, right)
; Game has food (position)

(define-struct game (worm food score))
(define-struct worm (head tail dir))
(define-struct posn (x y))

(define (render-game g)
  (cond
    [(hit-wall? (game-worm g)) (render-over)]
    [else
     (~> scn
         (render-worm (game-worm g))
         (render-food (game-food g)))]))

(define (hit-wall? w)
  (let ([x (posn-x (worm-head w))]
        [y (posn-y (worm-head w))])
    (cond
      [(or (>= x 1200)
           (>= y 800)
           (<= x 0)
           (<= y 0)) #t]
      [else #f])))

(define (render-win)
  (place-image (text "You won!" 20 "white") 200 200
               (empty-scene 1200 800 "green")))

(define (render-over)
  (place-image (text "Oh no! The worm hit a wall. Game over." 20 "white") 200 200 over))

(define (render-worm s w)
  (~> s
      (render-head (worm-head w))
      (render-tail (worm-tail w))))

(define (render-head s h)
  (place-image seg (posn-x h) (posn-y h) s))

(define (render-tail s ts)
  (cond
    [(empty? ts) s]
    [else (~> s
              (render-tail-item (first ts))
              (render-tail (rest ts)))]))

(define (render-tail-item s t)
  (place-image seg (posn-x t) (posn-y t) s))

(define (render-food s f)
  (place-image food (posn-x f) (posn-y f) s))

(define (tick-game g)
  (cond
    [(ate-food? (game-worm g) (game-food g))
     (make-game (lengthen-worm (game-worm g))
                (random-food) 0)]
    [else
     (make-game (move-worm (game-worm g))
                (game-food g)
                (+ 1 (game-score g)))]))

(define (ate-food? w f)
  (let ([h (worm-head w)])
    (and (= (posn-x h) (posn-x f))
         (= (posn-y h) (posn-y f)))))

(define (lengthen-worm w)
  (make-worm
   (move-head (worm-head w) (worm-dir w))
   (cons (worm-head w) (worm-tail w))
   (worm-dir w)))

; Random number by tens
(define (random-food)
  (make-posn (* 10 (random 4 120)) (* 10 (random 4 20))))

; New head 10 pixels down
; tail takes old head
; tail removes last posn
(define (move-worm w)
  (let ([h (worm-head w)]
        [t (worm-tail w)]
        [dir (worm-dir w)])
    (make-worm
     (move-head h dir)
     (move-tail h t)
     dir)))

; Move head a direction
(define (move-head h dir)
  (cond
    [(key=? dir "up") (make-posn (posn-x h) (- (posn-y h) 10))]
    [(key=? dir "down") (make-posn (posn-x h) (+ 10 (posn-y h)))]
    [(key=? dir "right") (make-posn (+ 10 (posn-x h)) (posn-y h))]
    [(key=? dir "left") (make-posn (- (posn-x h) 10) (posn-y h))]
    [else h]))

; Take over the last head position
; Remove the last item
(define (move-tail h t)
  (cons h (trim-tail t)))

(define (trim-tail t)
  (cond
    [(empty? (rest t)) empty]
    [else (cons (first t) (trim-tail (rest t)))]))

; handle key
; on direction, move head that direction
; move tail
(define (handle-key g k)
  (let* ([w (game-worm g)]
         [currdir (worm-dir w)]
         [h (worm-head w)]
         [t (worm-tail w)])
    (cond
      [(or (and (key=? k "right") (string=? currdir "left"))
           (and (key=? k "left") (string=? currdir "right"))
           (and (key=? k "up") (string=? currdir "down"))
           (and (key=? k "down") (string=? currdir "up"))) g]
      [else
    (make-game
     (make-worm (move-head h k) (move-tail h t) k)
     (game-food g)
     0)])))
  
(define wr
  (make-worm (make-posn 80 80)
             (list (make-posn 70 80)
                   (make-posn 60 80))
             "right"))

(define wl
  (make-worm (make-posn 80 80)
             (list (make-posn 90 80)
                   (make-posn 100 80))
             "left"))

(define wu
  (make-worm (make-posn 100 100)
             (list (make-posn 100 110)
                   (make-posn 100 120))
             "up"))

(define wd
  (make-worm (make-posn 40 60)
             (list (make-posn 40 50) (make-posn 40 40))
             "down"))

(define game1 (make-game wr (random-food) 0))

(big-bang game1
  [on-tick tick-game 0.1]
  [on-key handle-key]
  [on-draw render-game])