;; INCOMPLETE, kept for reference

(ns day_14.src.main
  (:require [clojure.java.io :as io]
            [clojure.string :as string]))

(defn readInputFile "Reads in the input file and returns list of coordinates." [input_file]
  (with-open [rdr (io/reader input_file)]
    (doseq [line (line-seq rdr)]
    ;;   (println line)
      (doseq [split_line (string/split line #" -> ")]
        (doseq [coords (string/split split_line #",")] (vec coords))))))

;; Setup the map
(def waterfall_map (for [_i (range 450 (inc 550))]
                     (for [_j (range 0 (inc 100))]
                       0)))
(println "Hello")
;; (def coords (readInputFile))
;; (println coords)
(doseq [coords (readInputFile "./data/input.dat")]
  (println coords))