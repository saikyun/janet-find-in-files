(print)

(defn replacer
  [peg replacement]
  ~(any (+ (* (/ ,peg
                 ,(fn [& _] replacement)))
           (<- 1))))

(defn replace-in-string
  [peg replacement s]
  (string ;(peg/match (replacer peg replacement)
                      s)))


(defn replace-in-file
  [peg replacement path]
  (print "Looking inside file: " path)
  (def result
    (with [f (file/open path :r)]
      (def content (:read f :all))
      (replace-in-string peg replacement content)))

  (with [f (file/open path :w)]
    (file/write f result))

  result
  #
)

(print (replace-in-file "inside of" "outside of" "./replacement_example"))

(print)

(comment
  (any (+ (* ($) "hello" ($))
          1))

  (replace-in-string "nice" "cute" "cat is nice")
  #=> "cat is cute"
  #
)
