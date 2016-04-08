module DNA where

toRNA :: String -> String
toRNA dna =
  map transcribe dna
  where
     transcribe base =
       case base of
         'G' -> 'C'
         'C' -> 'G'
         'T' -> 'A'
         'A' -> 'U'
         _ -> error $ "Invalid base" ++ show base
