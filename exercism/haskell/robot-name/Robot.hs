module Robot(randomName, mkRobot, robotName, resetName) where

import System.Random (randomRIO)
import Data.IORef (IORef, newIORef, readIORef, writeIORef)

type Robot = IORef String

randomName :: IO String
randomName = mapM randomRIO [letter, letter, number, number, number]
  where
    letter = ('A','Z')
    number = ('0','9')

mkRobot :: IO Robot
mkRobot = randomName >>= newIORef

robotName :: Robot -> IO String
robotName robot = readIORef robot

resetName :: Robot -> IO ()
resetName robot = randomName >>= writeIORef robot
