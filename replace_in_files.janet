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

(defn traverse-dir
  [f path &opt res]
  (default res @{})

  (let [files-and-folders (->> (os/dir path)
                               (filter |(not (string/has-prefix?
                                               "." $))))
        files (filter |(= ((os/stat (string path $)) :mode) :file)
                      files-and-folders)
        folders (filter |(= ((os/stat (string path $)) :mode) :directory)
                        files-and-folders)]
    (loop [v :in folders]
      (traverse-files f (string path v "/") res))

    (loop [v :in files
           :let [file-path (string path v)]]
      (put res file-path (f file-path)))

    res
    #
))

(defn replace-in-files
  [peg replacement dir]
  (traverse-dir |(replace-in-file peg replacement $) dir))

(print)

(comment
  (any (+ (* ($) "hello" ($))
          1))

  # prints the path lengths of all files inside ./
  (pp (traverse-dir length "./"))

  (replace-in-string "nice" "cute" "cat is nice")
  #=> "cat is cute"

  (print (replace-in-file "inside of" "outside of" "./replacement_example"))

  #
)
