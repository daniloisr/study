module Scorer where

import String exposing (indexes, length, fromChar, toList)
import Maybe exposing (withDefault)
import List exposing (head, append)

type alias Score =
  { acc: Float
  , nextIndex: Int
  , indexes: List Int
  , string: String
  }

-- simple score based on https://github.com/joshaven/string_score/blob/master/string_score.js
score : String -> String -> Float
score string word =
  let
    result = List.foldl
      computeScore
      { acc = 0, indexes = [], string = string, nextIndex = 0 }
      (toList word)

    stringLen = length string |> toFloat
    wordLen = length word |> toFloat
  in
    0.5 * (result.acc / stringLen + result.acc / wordLen)

computeScore : Char -> Score -> Score
computeScore char struct =
  let
    index = (indexes (fromChar char) struct.string)
      |> head
      |> withDefault -1
    val = if index == struct.nextIndex then 0.7 else 0.1
    nextIndex = index + 1
  in
    { struct | acc <- struct.acc + val
             , indexes <- (append struct.indexes [index])
             , nextIndex <- nextIndex
             }
