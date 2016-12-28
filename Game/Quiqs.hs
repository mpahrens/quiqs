{-#LANGUAGE GADTs, DeriveFunctor #-}
module Game.Quiqs
(

)where
-- game
import qualified Game.Quiqs.Board    as Bo
import qualified Game.Quiqs.Building as Bu
import qualified Game.Quiqs.Faction  as F
import qualified Game.Quiqs.Role     as R
-- free monad
import Control.Monad.Free (Free(..))
import qualified Control.Monad.Free as Free
-- Position manipulation
import Data.Vect

data Ent = Bld Bu.Building Vec3
         | Per R.Role Vec3
         | Fae R.Role Bu.Fae Vec3

-- Interpretter commands for a game of Quiqs
data Quiqs next =
    Login        String String  (R.Role -> next)
  | Logoff       (R.Role -> next)
  | Gather       (Int -> next)
  | SelNextEnemy (Ent -> next)
  | SelNextBuild (Ent -> next)
  | SelNextAlly  (Ent -> next)
  | MainAttack   Ent (Skirmish -> next)
  | SubAttack    Ent (Skirmish -> next)
  | Defend       next
  | Me           (Ent -> next)
  | UseAbility   R.Ability Ent (Skirmish -> next)
  | Build        Bu.Building (Ent -> next)
  | Move         Vec3 next
  | FaceDir      Direction next
  | EnterBoard   Bo.Board next
  | MkFae        Bu.Fae next
  | GiveCharms   Int Ent next
  | WearEquip    R.Equip (R.Role -> next)
  deriving (Functor)
data Direction = N | NE | E | SE | S | SW | W | NW
data Skirmish = Skirmish {msg :: String}

type QuiqGame = Free Quiqs

-- combinator forms
login :: String -> String -> QuiqGame R.Role
login sn pw = Free.liftF $ Login sn pw id

logoff :: QuiqGame R.Role
logoff = Free.liftF $ Logoff id

gather :: QuiqGame Int
gather = Free.liftF $ Gather id

selNextEnemy :: QuiqGame Ent
selNextEnemy = Free.liftF $ SelNextEnemy id

selNextAlly :: QuiqGame Ent
selNextAlly = Free.liftF $ SelNextAlly id

selNextBuild :: QuiqGame Ent
selNextBuild = Free.liftF $ SelNextBuild id

mainAttack :: Ent -> QuiqGame Skirmish
mainAttack target = Free.liftF $ MainAttack target id

subAttack :: Ent -> QuiqGame Skirmish
subAttack target = Free.liftF $ SubAttack target id

defend :: QuiqGame ()
defend = Free.liftF $ Defend ()

me :: QuiqGame Ent
me = Free.liftF $ Me id

useAbility :: R.Ability -> Ent -> QuiqGame Skirmish
useAbility ability target = Free.liftF $ UseAbility ability target id

build :: Bu.Building -> QuiqGame Ent
build b = Free.liftF $ Build b id

move :: Vec3 -> QuiqGame ()
move to = Free.liftF $ Move to ()

face :: Direction -> QuiqGame ()
face dir = Free.liftF $ FaceDir dir ()

enter :: Bo.Board -> QuiqGame ()
enter board = Free.liftF $ EnterBoard board ()

fae :: Bu.Fae -> QuiqGame ()
fae f = Free.liftF $ MkFae f ()

-- use like 3 `charmsTo` friend
charmsTo :: Int -> Ent -> QuiqGame ()
charmsTo n friend = Free.liftF $ GiveCharms n friend ()

wear :: R.Equip -> QuiqGame R.Role
wear equip = Free.liftF $ WearEquip equip id
