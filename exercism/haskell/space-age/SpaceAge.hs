module SpaceAge (Planet(..), ageOn) where

data Planet =
  Earth | Mercury | Venus | Mars | Jupiter | Saturn | Uranus | Neptune

ageOn :: (Fractional a) => Planet -> a -> a
ageOn planet secs =
  case planet of
    Earth   -> earthAge
    Mercury -> earthAge / 0.2408467
    Venus   -> earthAge / 0.61519726
    Mars    -> earthAge / 1.8808158
    Jupiter -> earthAge / 11.862615
    Saturn  -> earthAge / 29.447498
    Uranus  -> earthAge / 84.016846
    Neptune -> earthAge / 164.79132
  where
    earthAge = secs / 31557600