{-# LANGUAGE TypeApplications #-}

module Main where

import Data.Word
import Algebra
import System.IO.Echo
import GHC.Unicode
import Data.Function
import Data.Char

data Alphabet = Alphabet  -- Record: list of ranges and list of individual letters.

data EchoMode = Silent | Asterisk

main :: IO ()
main = do
    putStrLn "Enter salt:"
    salt <- getLine
    putStrLn "Enter secret:"
    secret <- getSecret Asterisk
    putStrLn "Enter desired password length:"
    passwordLength <- read @Int <$> getLine

    let patternSecret = (take passwordLength . concat . repeat) secret
        patternSalt = (take passwordLength . concat . repeat) salt

    putStrLn "Your password:"
    putStrLn $ zipWith (\c c' -> chr $ ((+) `on` ord) c c') patternSecret patternSalt

-- |
--
-- λ read "-3" :: Word8
-- 253
--
-- λ readWord8 "-3"
-- Nothing
-- 
-- λ readWord8 "3"
-- Just 3

readWord8 :: String -> Maybe Word8
readWord8 s | i == fromIntegral w    = Just w
            | otherwise = Nothing
  where
    i = read s :: Integer
    w = read s :: Word8

-- | Obtain a string of specified length, composed of nice characters, and do not echo it.
--   Optionally echo asterisks for additional visual niceness.
--
--   * In Silent mode, entering an illegal character errors out.
--
--   * In Asterisk mode, entering an illegal character does nothing.

getSecret :: EchoMode -> IO String
getSecret mode = fold <$> unfold
  where
    fold = reverse . fst . cataM2 distill
      where
        distill :: Maybe (String, a) -> (String, ())
        distill x = case x of { Just (s, _) -> (s, ()); Nothing -> ("", ()) }

    unfold = getCharSilently >>= anaM2 (getCharLoop mode)
      where

        getCharLoop :: EchoMode -> Char -> IO (Maybe (String, Char))
        getCharLoop mode c
            | c == '\n' = putChar '\n' >> return Nothing
            | isAscii c = maybePutAsterisk >> (\c' -> Just ([c], c')) <$> getCharSilently
            | otherwise = case mode of
                Silent -> fail "Illegal character."
                Asterisk -> getCharSilently >>= getCharLoop mode
          where
            maybePutAsterisk = case mode of
                Silent   -> return ()
                Asterisk -> putChar '*'

        getCharSilently :: IO Char
        getCharSilently = withoutInputEcho getChar


-- | Parse a string.similar to `a-zA-Z-_`.
getAlphabet :: String -> Alphabet
getAlphabet = undefined

-- | Warn if alphabet contains non-printable characters.
alphabetIsPrintable :: String -> Bool
alphabetIsPrintable = undefined

-- hasUnicode :: Alphabet -> Bool
-- hasUnicode = 

inAlphabet :: Char -> Alphabet -> Bool
inAlphabet _ _ = True
