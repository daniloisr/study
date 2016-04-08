(ns bob
  (use [clojure.string :as str :only [upper-case trim]]))

(defn nothing? [s]
  (empty? (str/trim s)))

(defn yelding? [s]
   (and (= (str/upper-case s) s)
        (re-find #"[A-Z]" s)))

(defn question? [s]
  (= (last (str/trim s)) \?))

(defn response-for [s]
  (cond
   (nothing? s) "Fine. Be that way!"
   (yelding? s) "Woah, chill out!"
   (question? s) "Sure."
   :else "Whatever."))