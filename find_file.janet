(print)

(defn finder
  [text]
  ~(any (+ (* ($) ,text ($))
           1)))

(defn find-in-file
  [peg path]
  (print "Looking inside file: " path)
  (with [f (file/open path :r)]
    (partition 2 (peg/match peg (:read f :all)))))

(defn find-in-files
  [peg path &opt res]
  (default res @{})
  (let [files-and-folders (os/dir path)
        files (filter |(= ((os/stat (string path $)) :mode) :file)
                      files-and-folders)
        folders (filter |(= ((os/stat (string path $)) :mode) :directory)
                        files-and-folders)]
    (loop [v :in folders]
      (find-in-files peg (string path v "/") res))

    (loop [v :in files
           :let [file-path (string path v)
                 matches (find-in-file peg file-path)]]
      (put res file-path matches))

    res
    #
))

(pp (find-in-files (finder "file") "./"))

(print)


(comment
  (os/dir "./")
  (os/dir "./sub-folder")
  (os/stat "./sub-folder")

  (pp (find-in-file (finder "file") "./goal"))
  #
)
