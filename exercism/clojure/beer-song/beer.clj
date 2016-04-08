(ns beer-song (:require [clojure.test :refer :all]))

(defn print-bottle [n]
  (if-let [s (str (if (> n 1) "s" ""))]
    (str n " bottle" s)))

(defn less-bottles [n]
  (let [n (- n 1)]
    (if (= 0 n)
      "Take it down and pass it around, no more bottles of beer on the wall"
      (str "Take one down and pass it around, " (print-bottle n) " of beer on the wall"))))

(defn verse [n]
  (if (= n 0)
    "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
    (str (print-bottle n) " of beer on the wall, " (print-bottle n) " of beer.\n" (less-bottles n) ".\n")))


(defn sing
  ([n] (sing n 0))
  ([n l] (clojure.string/join "\n" (map verse (range n (- l 1) -1)))))