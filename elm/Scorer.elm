module Scorer where

import String exposing (indexes, length, fromChar, toList)
import Maybe exposing (withDefault)
import List exposing (head, append)

type alias ScoreStruct =
  { acc: Float
  , sequencialIndex: Int
  , vals: List Float
  , indexes: List Int
  , string: String
  }

-- simple score based on https://github.com/joshaven/string_score/blob/master/string_score.js
score : String -> String -> ScoreStruct
score a b =
  let
    result = List.foldl
      (\a b ->
        let
          x = (indexes (fromChar a) b.string)
            |> head
            |> withDefault -1
          val = if x == b.sequencialIndex then 0.7 else 0.1
          nextIndex = x + 1
        in
          { b | acc <- b.acc + val
              , indexes <- (append b.indexes [x])
              , vals <- (append b.vals [val])
              , sequencialIndex <- nextIndex
              })
      { acc = 0, indexes = [], string = a, sequencialIndex = 0, vals = [] }
      (toList b)

    aLen = length a |> toFloat
    bLen = length b |> toFloat
  in
    { result | acc <- 0.5 * (result.acc / aLen + result.acc / bLen) }
