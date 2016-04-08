(ns anagram (:require [clojure.string :as str]))

(defn count-chars [s] (frequencies s))

(defn is-anagram? [a b]
  (let [a (str/lower-case a)
        b (str/lower-case b)]
    (and (= (count-chars a) (count-chars b))
         (not= a b))))

(defn anagrams-for [s as]
  (filter #(is-anagram? % s) as))