module Game.Quiqs.Board where
import Data.Vect

-- Represents a traversable game area
data Board = -- Major NPC area
             City {cSize :: Vec3}
             -- Custom player populated area
           | Town {tSize :: Vec3}
             -- Contestable battle arena area
           | Field {fSize :: Vec3}
