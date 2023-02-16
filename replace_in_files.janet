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
                        @{:start start
                          :stop stop
                          :line line
                          :match match}))
                  1))})

(defn find-in-file
  [peg path]
  (with [f (file/open path :r)]
    (def content (:read f :all))
    (->> (peg/match (finder peg) content)
         (map |(put $ :path path))))
  #
)

(defn replace-in-file
  [peg replacement path]
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
  [whole-match
   replacement]
  (def {:start start
        :stop stop
        :match match
        :path path
        :dry dry} whole-match)

  (def result
    (with [f (file/open path :r)]
      (:read f :all)))

  (unless (= match (string/slice result start stop))
    (error (string "matching string \"" match "\" is not equal to \""
                   (string/slice result start stop)
                   "\"")))

  (def new-content
    (buffer/new
      (+ (length result)
         (- (- stop start))
         (length replacement))))
  (buffer/blit new-content result 0 0 start)
  (buffer/push-string new-content replacement)
  (buffer/blit new-content result (length new-content) stop)

  (unless dry
    (with [f (file/open path :w)]
      (file/write f new-content)))

  (print "succesfully replaced")
  (pp whole-match)

  new-content)

(def delim (if (= :windows (os/which)) "\\" "/"))

(defn traverse-dir
  [f dir &keys {:res res
                :extension ext
                :no-recur no-recur}]
  (default res @{})

  (loop [filename :in (os/dir dir)
         :when (not (string/has-prefix? "." filename))
         :let [path (string dir delim filename)
               file? (= :file
                        ((os/stat path) :mode))]
         :when (or (not file?)
                   (not ext)
                   (string/has-suffix? ext filename))]
    (cond file?
      (put res path (f path))

      (not no-recur)
      (traverse-dir f
                    path
                    :res res
                    :extension ext)))

  res)

(defn replace-in-files
  [peg replacement dir]
  (traverse-dir |(replace-in-file peg replacement $) dir))

(defn find-in-files
  [peg dir & opts]
  (traverse-dir |(find-in-file peg $) dir
                ;opts))

(print)

#(replace-in-file-range match "freja/")

(setdyn :pretty-format "%.40M")

(def match (->> (find-in-files "render-cursor"
                               "../freja/freja"
                               #:no-recur true
                               :extension ".janet")
                (filter |(not (empty? $)))
                                flatten
                                #first
                #
))

#(replace-in-file-range match "\"freja-jaylib\"")

(pp match)


(comment
  # usage of find-in-files and replace-in-file-range
  (def [path matches] (first (pairs (find-in-files "yooo" "./sub-folder"))))
  (replace-in-file-range (first matches) "hello")

  # :dry true can be used as to not write to the file
  (def [path matches] (first (pairs (find-in-files "yooo" "./sub-folder"))))
  (pp (replace-in-file-range (put (first matches) :dry true) "hello"))

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
