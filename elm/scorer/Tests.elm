-- Example.elm
import String
import Scorer

import Graphics.Element exposing (..)
import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)

tests : Test
tests = suite "A Test Suite"
        [ test "Addition" (assertEqual (3 + 7) 10)
        , test "String.left" (assertEqual "a" (String.left 1 "abcdefg"))
        , test "This test should fail" (assert False)
        , test "Scorer is equal" (assertEqual (Scorer.score "Scorer" "Scorer") 1)
        , test "Scorer is zero" (assertEqual (Scorer.score "" "Scorer") 0)
        ]

main : Element
main = runDisplay tests
