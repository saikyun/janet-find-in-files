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

(defn finder
  [text]
  ~{:start-of-file-or-line (+ 0 "\n")
    :eof-or-line (+ -1 "\n")
    :looking-for ,text
    :main (any (+ (/ (* :start-of-file-or-line
                        (<- (* (to (+ "\n" :looking-for))
                               ($) (<- :looking-for) ($)
                               (to :eof-or-line)))
                        :eof-or-line)
                     ,(fn [start match stop line]
                        {:start start
                         :stop stop
                         :line line
                         :match match}))
                  1))})

(defn find-in-file
  [peg path]
  (print "Looking inside file: " path)
  (with [f (file/open path :r)]
    (def content (:read f :all))
    (peg/match (finder peg) content))
  #
)

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

(defn replace-in-file-range
  [start stop match replacement path]

  (print "Looking inside file: " path)
  (def result
    (with [f (file/open path :r)]
      (:read f :all)))

  #(with [f (file/open path :w)]
  #  (file/write f result))

  result)

(pp (replace-in-file-range 1 5 "hello" "yo" "./replace_in_files.janet"))

(def delim (if (= :windows (os/which)) "\\" "/"))

(defn traverse-dir
  [f dir &opt res]
  (default res @{})

  (loop [filename :in (os/dir (tracev dir))
         :when (not (string/has-prefix? "." filename))
         :let [path (string dir filename)
               file? (= :file
                        ((os/stat path) :mode))]]
    (if file?
      (put res path (f path))
      (traverse-dir f (string path delim) res)))

  res)

(defn replace-in-files
  [peg replacement dir]
  (traverse-dir |(replace-in-file peg replacement $) dir))

(defn find-in-files
  [peg dir]
  (traverse-dir |(find-in-file peg $) dir))

(print)


(comment
  (pp (find-in-files "hello" "./"))

  (any (+ (* ($) "hello" ($))
          1))

  # prints the path lengths of all files inside ./
  (pp (traverse-dir length "./"))

  (replace-in-string "nice" "cute" "cat is nice")
  #=> "cat is cute"

  (print (replace-in-file "inside of" "outside of" "./replacement_example"))

  #
)

(defn lul [])
