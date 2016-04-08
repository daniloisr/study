(ns word-count
  (require [clojure.string :as str]))

(defn only-alpha-numeric [s]
  (str/replace (str/lower-case s) #"[^a-zA-Z 0-9]+" ""))

(defn word-count
  [s]
    (frequencies (str/split (only-alpha-numeric s) #" +")))