-----------------------------------------------------------------------------
--
-- Module      :  Cell
-- Copyright   :
-- License     :  BSD3
--
-- Maintainer  :  agocorona@gmail.com
-- Stability   :  experimental
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------

module Haste.HPlay.Cell  where
import Haste.HPlay.View
import Control.Monad.IO.Class
import Haste
import Data.Typeable
import Unsafe.Coerce


data Cell  a = Cell { mk :: Maybe a -> Widget a
                    , setter ::  a -> IO()
                    , getter ::  IO a}

--instance Functor Cell where
--  fmap f cell = cell{setter= \c x ->  c .= f x, getter = \cell -> get cell >>= return . f}



boxCell id = Cell{ mk= \mv -> getParam (Just id) "text" mv
                , setter= \ x -> withElem id $ \e -> setProp e "value" (show1 x)
                , getter=  withElem id $ \e -> getProp e "value" >>= return . read1}
     where
     show1 x= if typeOf x== typeOf (undefined :: String)
                                then unsafeCoerce x
                                else show x
     read1 s= if typeOf s== typeOf (undefined :: String)
                                then unsafeCoerce s
                                else read s

(.=) cell x = liftIO $ (setter cell )  x

get cell = liftIO $ getter cell


(..=) cell cell'= get cell' >>= (.=) . cell

infixr 0 .=, ..=

-- experimental: to permit cell arithmetic

instance Num a => Num (Cell a) where
  c + c'= Cell undefined undefined  $
            do r1 <- get c
               r2 <- get c'
               return $ r1 + r2

  c * c'= Cell undefined undefined $
            do r1 <- get c
               r2 <- get c'
               return $ r1 * r2

  abs c= c{getter=  get c >>= return . abs}

  signum c= c{getter=  get c >>= return . signum}

  fromInteger i= Cell  undefined undefined  . return $ fromInteger i

