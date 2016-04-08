(ns rna-transcription)

(defn dna->rna [base]
  (condp = base
    \G "C"
    \C "G"
    \T "A"
    \A "U"
    (throw (new AssertionError))))

(defn to-rna [dna]
    (clojure.string/join (map dna->rna dna)))