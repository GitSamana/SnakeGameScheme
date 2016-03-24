;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |SnakeGame|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t write repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)
;                                       ;                   ;            
;                                      ;;                  ;;            
;                                      ;;                  ;;            
;                                      ;                   ;             
;                                      ;                   ;             
;                            ;;;;;     ;                   ;       ;;;;; 
;     ;;     ;;  ;;   ;;     ;   ;     ;     ;;   ;;       ;       ;   ; 
;   ;; ;;   ;;;;  ;   ; ;   ;      ;;;;;;;;;  ;   ; ;  ;;;;;;;;;  ;      
;   ;;     ;   ;  ;  ;  ;    ;         ;      ;  ;  ;      ;       ;     
;   ;      ;   ;  ;;;   ;;    ;;;      ;    ; ;;;   ;;     ;    ;   ;;;  
;   ;    ; ;   ;  ;;;   ;;       ;     ;  ;;  ;;;   ;;     ;  ;;       ; 
;   ;   ;  ;  ;    ;     ; ;;    ;;    ;;;     ;     ;     ;;;   ;;    ;;
;   ;;;;   ;;;;    ;        ;;;;;     ;        ;          ;       ;;;;;  
;                            ;;                                    ;;    


; constant for the radius size of the circle that will be a segment of the snake
(define RADIUS 10)

; constant for the radius size of the small circle for the snake
(define SMALL-RADIUS 6)

; constant for the radius size of the small circle for the snake
(define SMALLER-RADIUS 4)

; constant for the diameter of the circle that will be a segment of the snake
; the snake will move by this amount in each step
(define DIAMETER 20)

; constant equal to negative value of diameter
; this will be used when the snake has to move along the negative x or y axes
(define NEG-DIAM (* -1 DIAMETER))

; constant for each circle that will make up the snake
(define CIRCLE 
  (overlay
   (circle SMALLER-RADIUS 'solid 'FireBrick)
   (circle SMALL-RADIUS 'solid 'Red)
   (circle RADIUS 'solid 'DarkRed)))

; constant for food
(define FOOD
  (overlay
   (square (- RADIUS 6) 'solid 'gold)
   (square RADIUS 'solid 'DarkOrange)
   (circle RADIUS 'solid 'Olive)))

; constant for each side of the scene and the square to be overlain on it 
(define SIDE 400)

; constant empty scene to be used when creating each new scene 
(define SCN 
  (overlay
   (square SIDE 'solid 'White)
   (empty-scene SIDE SIDE)))

; constant for the rate of the clock that affects the speed of the snake 
(define RATE (/ 1 8))

; constant for the side length of star polygon
(define SIDE-LENGTH 50)

; constant for the side count of star polygon
(define SIDE-COUNT 7)

; constant for the step count for star polygon
(define STEP-COUNT 3)

; constant for the text size in final scene
(define TEXT-SIZE 40)


;constant for image of final explosion

(define EXPLOSION
  (overlay
   (star-polygon	 	
    (- SIDE-LENGTH 10)	 	 	 	 
    SIDE-COUNT	 	 	 
    STEP-COUNT	 	 
    'solid	 	 	 	 
    'gold)
   (star-polygon	 	
    SIDE-LENGTH	 	 	 	 
    SIDE-COUNT	 	 	 
    STEP-COUNT	 	 
    'solid	 	 	 	 
    'yellow)))



;                                                 
;       ;             ;;                          
;       ;            ;;;;                         
;       ;            ;  ;;                        
;       ;            ;                            
;       ;            ;                            
;       ;            ;;     ;;;                   
;       ;     ;;;    ;;    ;                 ;;;  
;    ;; ;    ;  ;;   ;;         ;;   ;;     ;  ;; 
;   ;; ;;;  ;   ;; ;;;;;;;; ;    ;   ; ;   ;   ;; 
;   ;   ;;  ;  ;;     ;;     ;   ;  ;  ;   ;  ;;  
;   ;   ;;  ;;;;      ;;     ;;  ;;;   ;;  ;;;;   
;   ;   ;;  ;     ;   ;;     ;;  ;;;   ;;  ;     ;
;   ;;;;;   ;; ;;;    ;;     ;;   ;     ;  ;; ;;; 
;    ;;;     ;;;      ;      ;    ;         ;;;   
;                     ;                           
;               ;                                 ;            
;              ;;                                ;;            
;              ;;                                ;;            
;              ;                                 ;             
;              ;                                 ;             
;    ;;;;;     ;     ;     ;;                    ;       ;;;;; 
;    ;   ;     ;      ;  ;; ;   ;   ;    ;;      ;       ;   ; 
;   ;      ;;;;;;;;;  ; ;;     ;    ;  ;; ;; ;;;;;;;;;  ;      
;    ;         ;      ;;;      ;    ;  ;;        ;       ;     
;     ;;;      ;    ; ;;;      ;    ;  ;         ;    ;   ;;;  
;        ;     ;  ;;   ;;      ;   ;;  ;    ;    ;  ;;       ; 
;  ;;    ;;    ;;;     ;;      ;; ;;;  ;   ;     ;;;   ;;    ;;
;   ;;;;;     ;        ;;      ;;;; ;  ;;;;     ;       ;;;;;  
;    ;;                 ;       ;;  ;                    ;;    
;                                                              


; the struct containing structs of snake segments and food
(define-struct sg (segs food))

; the struct containing elements of segs and food structs
(define-struct seg (x y dx dy))





;                                
;                           ;    
;                          ;;    
;                          ;;    
;                          ;     
;   ;;;            ;;;     ;     
;  ;              ;        ;     
;       ;;   ;;            ;     
;   ;    ;   ; ;   ;   ;;;;;;;;; 
;    ;   ;  ;  ;    ;      ;     
;    ;;  ;;;   ;;   ;;     ;    ;
;    ;;  ;;;   ;;   ;;     ;  ;; 
;    ;;   ;     ;   ;;     ;;;   
;    ;    ;         ;     ;                                                     
;                                              
;               ;                  ;            
;              ;;                 ;;            
;              ;;                 ;;            
;              ;                  ;             
;              ;        ;;;       ;             
;    ;;;;;     ;       ;;;;;      ;        ;;;  
;    ;   ;     ;      ;    ;      ;       ;  ;; 
;   ;      ;;;;;;;;; ;     ;  ;;;;;;;;;  ;   ;; 
;    ;         ;        ;;;;;     ;      ;  ;;  
;     ;;;      ;    ;  ;   ;;     ;    ; ;;;;   
;        ;     ;  ;;   ;   ;;     ;  ;;  ;     ;
;  ;;    ;;    ;;;     ;  ;;;     ;;;    ;; ;;; 
;   ;;;;;     ;        ;;;       ;        ;;;   
;    ;;                                         
;                                               


; list of segs that make up the snake
(define INIT-SEG-LIST (list
                       (make-seg 40 80 0 DIAMETER)
                       (make-seg 40 60 0 DIAMETER)
                       (make-seg 40 40 0 DIAMETER)))


; seg to make the food
(define INIT-FOOD-SEG (make-seg 120 100 0 0))

; initial state struct containing the snake and the food
(define GAME (make-sg INIT-SEG-LIST INIT-FOOD-SEG))





;                                                                     
;   ;                                ;                                
;   ;                                ;                                
;   ;                                ;                                
;   ;      ;;;                       ;        ;;;                     
;   ;     ;      ;;;                 ;       ;;;;;              ;;;   
;   ; ;;;        ; ;        ;;;;;;   ; ;;;  ;    ;  ;;   ;;     ; ;   
;   ;;   ; ;    ;; ;;    ;;;;;;;;    ;;   ;;     ;   ;   ; ;   ;; ;;  
;   ;;   ;  ;   ;; ;;   ;;;;;;       ;;   ;   ;;;;;  ;  ;  ;   ;; ;;  
;   ;;   ;  ;;  ;   ;                ;;   ;  ;   ;;  ;;;   ;;  ;   ;  
;   ;; ;;   ;;  ;   ;                ;; ;;   ;   ;;  ;;;   ;;  ;   ;  
;   ;;;;    ;;  ;;;;;;               ;;;;    ;  ;;;   ;     ;  ;;;;;; 
;    ;      ;   ;;; ;;                ;      ;;;      ;        ;;; ;; 
;                   ;;                                             ;; 
;                   ;;                                             ;; 
;                   ;;                                             ;; 
;                   ;;                                             ;; 
;                  ;;                                             ;;  
;                 ;;                                             ;;   
;                 ;                                              ;    
;                                                                     

;; Contract: (main) -> world state (a seg)
;; Input:    none
;; Purpose:  Invoke the big-bang animation engine to start a simulation
;;           of the snake GAME, using the initial state defined above (seg-lis)
;;           as the first argument to big-bang.

;; Function definition 

(define (main)
  (big-bang GAME
            ;calling draw-game to create the required image on an empty scene
            (on-draw draw-game)
            ;calling move-and-eat which regulates movement of the snake 
            ;according to the RATE of time and adds segments to the snake as 
            ;it eats food
            (on-tick move-and-eat RATE)
            ;calling steer-snake to change direction of the snake depending 
            ;on the key pressed
            (on-key steer-snake)
            ;checking to see if the first seg has either gone off scene or is 
            ;about to touch one of the snake's segments, 
            ;in which case the game ends 
            (stop-when snake-dead? draw-final)))




;                                                                               
;                                   ;            ;;                           ; 
;                                   ;           ;       ;                     ; 
;                                   ;           ;                             ; 
;    ;;;    ;;;;   ;;;           ;;;;   ;;;   ;;;;;   ;;;   ; ;;    ;;;    ;;;; 
;   ;   ;  ;;  ;  ;   ;         ;; ;;  ;;  ;    ;       ;   ;;  ;  ;;  ;  ;; ;; 
;   ;      ;   ;  ;             ;   ;  ;   ;;   ;       ;   ;   ;  ;   ;; ;   ; 
;    ;;;   ;   ;   ;;;          ;   ;  ;;;;;;   ;       ;   ;   ;  ;;;;;; ;   ; 
;       ;  ;   ;      ;         ;   ;  ;        ;       ;   ;   ;  ;      ;   ; 
;   ;   ;  ;; ;;  ;   ;         ;; ;;  ;        ;       ;   ;   ;  ;      ;; ;; 
;    ;;;    ;;;;   ;;;           ;;;;   ;;;;    ;     ;;;;; ;   ;   ;;;;   ;;;; 
;              ;                                                                
;           ;  ;                                                                
;            ;;                                                                 
;                                                                 
;      ;;                              ;                    ;     
;     ;                                ;                    ;     
;     ;                                ;                    ;     
;   ;;;;;   ;;;    ;;;;          ;;;   ; ;;    ;;;    ;;;   ;  ;  
;     ;    ;; ;;   ;;  ;        ;;  ;  ;;  ;  ;;  ;  ;;  ;  ;  ;  
;     ;    ;   ;   ;            ;      ;   ;  ;   ;; ;      ; ;   
;     ;    ;   ;   ;            ;      ;   ;  ;;;;;; ;      ;;;   
;     ;    ;   ;   ;            ;      ;   ;  ;      ;      ; ;   
;     ;    ;; ;;   ;            ;;     ;   ;  ;      ;;     ;  ;  
;     ;     ;;;    ;             ;;;;  ;   ;   ;;;;   ;;;;  ;   ; 
;                                                                 
;                                                                 
;                                                                 
;                                                   
;                                                   
;                                        ;          
;                                        ;          
;    ;;;   ;   ;  ;;;;    ;;;    ;;;   ;;;;;   ;;;  
;   ;;  ;   ; ;   ;; ;;  ;;  ;  ;;  ;    ;    ;   ; 
;   ;   ;;  ;;;   ;   ;  ;   ;; ;        ;    ;     
;   ;;;;;;   ;    ;   ;  ;;;;;; ;        ;     ;;;  
;   ;       ;;;   ;   ;  ;      ;        ;        ; 
;   ;       ; ;   ;; ;;  ;      ;;       ;    ;   ; 
;    ;;;;  ;   ;  ;;;;    ;;;;   ;;;;    ;;;   ;;;  
;                 ;                                 
;                 ;                                 
;                 ;                                 


(define game-1
  (make-sg
   (list 
    (make-seg 40 40 0 20)
    (make-seg 40 60 0 20)
    (make-seg 40 80 0 0))
   (make-seg 120 200 0 0)))

(define game-2
  (make-sg
   (list 
    (make-seg 40 40 0 20)
    (make-seg 40 60 20 0)
    (make-seg 40 80 0 20))
   (make-seg 40 60 0 0)))

(define h
  (make-sg
   (list
    (make-seg 30 40 50 0)
    (make-seg 30 40 50 0))
   (make-seg 30 40 30 40)))


(define off-1
  (make-sg 
   (list
    (make-seg 0 200 40 40)
    (make-seg 40 200 40 40)
    (make-seg 80 200 40 40))
   (make-seg 70 80 0 0)))

(define off-2
  (make-sg
   (list
    (make-seg 200 130 40 40)
    (make-seg 200 130 40 40)
    (make-seg 200 190 40 40))
   (make-seg 70 80 0 0)))

(define off-3
  (make-sg
   (list
    (make-seg 200 400 40 40)
    (make-seg 200 400 40 40)
    (make-seg 280 380 40 40))
   (make-seg 70 80 0 0)))





;                                                   
;                                                   
;   ;   ;         ;;;                               
;   ;   ;           ;                               
;   ;   ;   ;;;     ;    ;;;;    ;;;    ;;;;   ;;;  
;   ;   ;  ;;  ;    ;    ;; ;;  ;;  ;   ;;  ; ;   ; 
;   ;;;;;  ;   ;;   ;    ;   ;  ;   ;;  ;     ;     
;   ;   ;  ;;;;;;   ;    ;   ;  ;;;;;;  ;      ;;;  
;   ;   ;  ;        ;    ;   ;  ;       ;         ; 
;   ;   ;  ;        ;    ;; ;;  ;       ;     ;   ; 
;   ;   ;   ;;;;     ;;  ;;;;    ;;;;   ;      ;;;  
;                        ;                          
;                        ;                          
;                        ;                          


;; Contract: (draw-seg-lis lis) -> image (scene)
;; Input:    lis is a list of segs
;; Purpose:  draw each component of lis at the x and y coordinates it 
;;           contains on the eMpTy scene


;; Function definition 

(define (draw-seg-lis lis)
  (cond
    ;checking if the list is empty, and returning the empty scene
    [(empty? lis) SCN]
    [else 
     ;placing the circle (in the current x and y coordinates from INIT-SEG-LIST)
     ;to be used as a segment of snake on the scene that 
     ;constantly changes as the function draw-seg-list is called until all 
     ;elements of INIT-SEG-LIST are used
     (place-image
      CIRCLE
      (seg-x (first lis))
      (seg-y (first lis))
      (draw-seg-lis (rest lis)))]))




;; Contract: (FOOD? lis food-seg) -> boolean
;; Input:    lis is a list of snake segments, food-seg is a food seg 
;; Purpose:  checks if the coordinates of the head of the snake is the same as 
;;           those of the food

;; Pre-function tests:

(check-expect (FOOD? game-1)
              #f)
(check-expect (FOOD? game-2)
              #t)


; Function definition


(define (FOOD? game)
  ;returning true if the x and y coordinates of the first seg in the next step 
  ;will be equal to those of food
  (and
   (= (+ (seg-x (first (sg-segs game))) (seg-dx (first (sg-segs game)))) 
      (seg-x (sg-food game)))
   (= (+ (seg-y (first (sg-segs game))) (seg-dy (first (sg-segs game)))) 
      (seg-y (sg-food game)))))



;; Contract: (random-food game) -> seg
;; Input:    game is an sg 
;; Purpose:  makes a new seg with random values as x and y coordinates for food 
;;           the function is called recursively if the food overlaps with the 
;;           snake


; Function definition

(define (random-food game)
  (local
    ; defining a new seg with random x and y coordinates to produce new food
    [(define new-food
       (make-seg (* 20 (add1 (random 19))) (* 20 (add1 (random 19))) 0 0))]
    ;checking if the food overlaps with any snake seg using food-snake-overlap?
    (cond
      [(food-snake-overlap? game)
       (random-food game)]
      ;else retuning new-food
      [else
       new-food])))



;;; Contract: (food-snake-overlap? game) -> boolean
;;; Input:    game is an sg 
;;; Purpose:  checks if the food and any of the snake segments are overlapping 
;


;; Pre-function tests:

(check-expect (food-snake-overlap? game-1) #f)
(check-expect (food-snake-overlap? game-2) #t)




;;; Function definition:
;;
(define (food-snake-overlap? game)
  (cond
    ;returning false if end of list is reached
    [(empty? (sg-segs game)) #f]
    ;returning true if x and y coordinates of the first seg in list of snake 
    ;segs is equal to those of food
    [(and (= (seg-x (first (sg-segs game))) (seg-x (sg-food game)))
          (= (seg-y (first (sg-segs game))) (seg-y (sg-food game))))
     #t]
    ;calling function on rest of list to check 2nd case on all segs till list is
    ;empty
    [else (food-snake-overlap? 
           (make-sg (rest (sg-segs game)) (sg-food game)))]))




;; Contract: (remove-last lis1) -> seg
;; Input:    lis1 is a list of segs
;; Purpose:  produces a list of segs with all but the last seg in the initial 
;;           list (lis1) 


; Function definition

(define (remove-last lis1)
  ;taking the rest of the reversed lis1 to get all except the last element
  ;reversing the received list to get the elements in the order of initial lis
  (reverse (rest (reverse lis1))))




;; Contract: (new-head lis2) -> seg
;; Input:    lis2 is a list of segs
;; Purpose:  add a new head in the new direction 


; Function definition

(define (new-head lis2)
  ;making a new seg with the current dx and dy values added to the x and y 
  ;coordinates 
  (make-seg
   (+ (seg-x (first lis2)) (seg-dx (first lis2))) 
   (+ (seg-y (first lis2)) (seg-dy (first lis2))) 
   (seg-dx (first lis2)) (seg-dy (first lis2))))




;; Contract: (off-scene? game) -> boolean
;; Input:    game is an sg
;; Purpose:  stop the simulation if first segment is off the scene


; pre function tests:
;
(check-expect (off-scene? off-1) #t)
(check-expect (off-scene? off-2) #f)
(check-expect (off-scene? off-3) #t)


; Function definition

(define (off-scene? game)
  (or
   ;checking if x-coordinate of first seg is at the left-most edge of screen 
   (= (seg-x (first (sg-segs game))) 0)
   ;checking if x-coordinate of first seg is at the right-most edge of screen
   (= (seg-x (first (sg-segs game))) SIDE)
   ;checking if y-coordinate of first seg is at the top-most edge of screen
   (= (seg-y (first (sg-segs game))) 0)
   ;checking if x-coordinate of first seg is at the bottom-most edge of screen
   (= (seg-y (first (sg-segs game))) SIDE))
  ;and returning true if any of the above cases are true
  )




;; Contract: (hit-self? game) -> boolean
;; Input:    game is an sg
;; Purpose:  stop the simulation if first segment is on the same coordinates as
;;           any other segment of snake



; pre function tests

(check-expect (hit-self? off-1) #f)
(check-expect (hit-self? off-2) #t)
(check-expect (hit-self? off-3) #t)


; Function definition

(define (hit-self? game)
  (local
    ;storing the values of x and y coordinates of first element of lis 
    [(define FIRSTX (seg-x (first (sg-segs game))))
     (define FIRSTY (seg-y (first (sg-segs game))))
     ;defining a helper function 
     (define (hit-self?-helper game)
       (cond
         ;base case to check if list from
         ;sg-segs is empty and return false if it is
         [(empty? (sg-segs game)) #f]
         ;returning true if the x and y coordinates of the first of list are 
         ;equal to those stored in FIRSTX and FIRSTY  
         [(and (eq? FIRSTX (seg-x (first (sg-segs game))))
               (eq? FIRSTY (seg-y (first (sg-segs game))))) #t]
         ;making recursive call on rest of list
         [else (hit-self?-helper 
                (make-sg (rest (sg-segs game)) (sg-food game)))]))]
    ;making initial call to helper function by passing in rest of lis
    (hit-self?-helper (make-sg (rest (sg-segs game)) (sg-food game)))))




;                                       ;     
;                                       ;     
;     ;;;       ;    ;;;                ;     
;    ;  ;; ;    ;   ;  ;; ;;   ;;       ;     
;   ;   ;;  ;   ;  ;   ;;  ;   ; ;  ;;;;;;;;; 
;   ;  ;;   ;   ;  ;  ;;   ;  ;  ;      ;     
;   ;;;;    ;; ;   ;;;;    ;;;   ;;     ;    ;
;   ;     ; ;; ;   ;     ; ;;;   ;;     ;  ;; 
;   ;; ;;;   ;;;   ;; ;;;   ;     ;     ;;;   
;    ;;;     ;;     ;;;     ;          ;      
;                                                                               
;   ;                               ;                                
;   ;;                              ;                                
;   ;;                              ;   ;;                           
;   ;;                              ;   ;;                           
;   ;                               ;   ;;                           
;   ;          ;;;                  ;   ;;                           
;   ;;        ;;;;;                 ;   ;;     ;;;  ;     ;;   ;;;;; 
;   ;;  ;    ;    ;  ;;   ;;     ;; ;    ;    ;  ;;  ;  ;; ;   ;   ; 
;   ;;;; ;  ;     ;   ;   ; ;   ;; ;;;   ;;  ;   ;;  ; ;;     ;      
;   ;;;   ;    ;;;;;  ;  ;  ;   ;   ;;   ;;  ;  ;;   ;;;       ;     
;    ;    ;   ;   ;;  ;;;   ;;  ;   ;;   ;;  ;;;;    ;;;        ;;;  
;    ;     ;  ;   ;;  ;;;   ;;  ;   ;;   ;;  ;     ;  ;;           ; 
;    ;;       ;  ;;;   ;     ;  ;;;;;     ;  ;; ;;;   ;;     ;;    ;;
;    ;        ;;;      ;         ;;;      ;   ;;;     ;;      ;;;;;  
;                                                      ;       ;;    






;; Contract: (draw-game game) -> image (scene)
;; Input:    game is an sg 
;; Purpose:  draw food and text image of the current number of segments in 
;;           the snake on a scene containing the image of the snake segments
;;           

;; Function definition 

(define (draw-game game)
  (place-image
   ;placing food on the scene using the x and y coordinates stored in the food 
   ;struct
   FOOD
   (seg-x (sg-food game))
   (seg-y (sg-food game))
   ;the scene on which the food is placed has an image of the number of segments
   ;in the snake at any any given time
   (place-image
    ;using number->string on length of the list of segments to get a string 
    ;displaying number of snake segments
    (text (number->string (length (sg-segs game))) 16 'LightSeaGreen)
    380
    380
    ;placing the food and number of segments on a scene drawn by calling 
    ;draw-segs-lis on (sg-segs game), which draws the segments of the snake 
    (draw-seg-lis (sg-segs game)))))




;; Contract: (move-and-eat game) -> sg
;; Input:    game is an sg 
;; Purpose:  adds a new segment to the head of the snake with the coordinates of
;;           the food and dx and dy of the head of the snake when snake eats 
;;           food. adds a new head and removes the tail when no food is eaten


; Function definition

(define (move-and-eat game)
  (cond
    ;making new seg with coordinates of food and dx and dy of head of first seg
    ;of snake segs list to existing list if FOOD? returns true 
    [(FOOD? game)
     (make-sg (cons (make-seg (seg-x (sg-food game)) 
                              (seg-y (sg-food game))
                              (seg-dx (first (sg-segs game))) 
                              (seg-dy (first (sg-segs game)))) (sg-segs game))
              ;placing food at random new place
              (random-food game))]
    ;making new sg by adding a new head and removing tail seg
    [else
     (make-sg (cons (new-head (sg-segs game)) (remove-last (sg-segs game))) 
              (sg-food game))]))




;; Contract: (steer-snake game kee) -> sg
;; Input:    game is an sg
;; Purpose:  moves the snake in new direction by adding a new seg in the 
;;           new direction by adding a new seg with changed dx or dy value to 
;;           the rest of the list of segs of snake


;; Pre-function tests 

(check-expect (steer-snake game-1 "up")  
              (make-sg
               (list 
                (make-seg 40 40 0 NEG-DIAM)
                (make-seg 40 60 0 20)
                (make-seg 40 80 0 0))
               (make-seg 120 200 0 0)))
(check-expect (steer-snake game-1 "down")  
              (make-sg
               (list 
                (make-seg 40 40 0 DIAMETER)
                (make-seg 40 60 0 20)
                (make-seg 40 80 0 0))
               (make-seg 120 200 0 0)))
(check-expect (steer-snake game-1 "left")  
              (make-sg
               (list 
                (make-seg 40 40 NEG-DIAM 0)
                (make-seg 40 60 0 20)
                (make-seg 40 80 0 0))
               (make-seg 120 200 0 0)))
(check-expect (steer-snake game-1 "right")  
              (make-sg
               (list 
                (make-seg 40 40 DIAMETER 0)
                (make-seg 40 60 0 20)
                (make-seg 40 80 0 0))
               (make-seg 120 200 0 0)))
(check-expect (steer-snake game-1 "s")  
              (make-sg
               (list 
                (make-seg 40 40 0 20)
                (make-seg 40 60 0 20)
                (make-seg 40 80 0 0))
               (make-seg 120 200 0 0)))


; Function definition

(define (steer-snake game kee)
  (cond
    ;adding a new seg in negative y direction (by changing the dy value by 
    ;NEG-DIAM) if "up" is pressed
    [(string=? kee "up") 
     (make-sg (cons (make-seg (seg-x (first (sg-segs game))) 
                              (seg-y (first (sg-segs game))) 
                              0 NEG-DIAM) (rest (sg-segs game))) 
              (sg-food game))]
    ;adding a new seg in positive y direction (by changing the dy value by 
    ;DIAMETER) if "down" is pressed
    [(string=? kee "down") 
     (make-sg (cons (make-seg (seg-x (first (sg-segs game))) 
                              (seg-y (first (sg-segs game))) 
                              0 DIAMETER) (rest (sg-segs game)))
              (sg-food game))]
    ;adding a new seg in negative x direction (by changing the dx value by 
    ;NEG-DIAM) if "left" is pressed
    [(string=? kee "left") 
     (make-sg (cons (make-seg (seg-x (first (sg-segs game))) 
                              (seg-y (first (sg-segs game))) 
                              NEG-DIAM 0) (rest (sg-segs game)))
              (sg-food game))]
    ;adding a new seg in positive x direction (by changing the dx value by 
    ;DIAMETER) if "right" is pressed
    [(string=? kee "right") 
     (make-sg (cons (make-seg (seg-x (first (sg-segs game))) 
                              (seg-y (first (sg-segs game))) 
                              DIAMETER 0) (rest (sg-segs game)))
              (sg-food game))]
    ;not making any changes to the movement of the segments if any other key is 
    ;pressed by passing the initial value of games
    [else game]))







;; Contract: (snake-dead? lis) -> boolean
;; Input:    game is an sg
;; Purpose:  stop the simulation if either hit-self? or off-scene is returned
;;           true


; pre function tests

(check-expect (snake-dead? off-1) #t)
(check-expect (snake-dead? off-2) #t)
(check-expect (snake-dead? off-3) #t)


; Function definition

(define (snake-dead? game)
  ;returning true if either hit-self? or off-scene? return true
  (or
   (hit-self?  game)
   (off-scene? game)))




;; Contract: (draw-final INIT-SEG-LIST) -> image (scene)
;; Input:    INIT-SEG-LIST is a list of seg structs
;; Purpose:  Create the last scene when the snake hits the wall

;; Function definition:

(define (draw-final game)
  (overlay
   ;placing text in the final scene to say the user lost the GAME 
   (text "BOOM! You lose!!!" TEXT-SIZE 'DarkMagenta)
   ;placing a star-like explosion to show death of the snake
   (place-image
    EXPLOSION
    ;placing the explosion one step before the point where first seg goes out 
    ;of scene
    (+ (* -1 (seg-dx (first (sg-segs game)))) (seg-x (first (sg-segs game))))
    (+ (* -1 (seg-dy (first (sg-segs game)))) (seg-y (first (sg-segs game))))
    (draw-game game))))


(main)
