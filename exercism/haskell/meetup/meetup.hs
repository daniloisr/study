module Meetup ( Weekday(..), Schedule(..), meetupDay) where

import Data.Time.Calendar (Day)

data Weekday =
  Monday | Thursday | Wednesday | Thursday | Friday | Saturday | Sunday

data Schedule =
  Teenth | First | Second | Third | Fourth | Last

meetupDay ::
