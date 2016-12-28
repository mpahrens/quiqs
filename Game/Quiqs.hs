{-#LANGUAGE GADTs, DerivingFunctor #-}
module Quiqs
(

)where
-- game
import qualified Game.Quiqs.Board    as Bo
import qualified Game.Quiqs.Building as Bu
import qualified Game.Quiqs.Faction  as F
import qualified Game.Quiqs.Role     as R
-- free monad
import Data.Free (Free(..))
import qualified Data.Free as Free
-- Position manipulation
import Data.Vect

type Ent = Bld Bu.Building Vec3
         | Per P.Role Vec3
         | Fae P.Role Bu.Fae Vec3

-- Interpretter commands for a game of Quiqs
data Quiqs a next where
  Login        :: String -> String -> (R.Role -> next) -> Quiqs R.Role next
  Logoff       :: (R.Role -> next) -> Quiqs R.Role next
  Gather       :: (Int -> next) -> Quiqs Int next
  SelNextEnemy :: (Ent -> next) -> Quiqs Ent next
  SelNextBuild :: (Ent -> next) -> Quiqs Ent next
  SelNextAlly  :: (Ent -> next) -> Quiqs Ent next
  MainAttack   :: Ent -> (Skirmish -> next) -> Quiqs Skirmish next
  SubAttack    :: Ent -> (Skirmish -> next) -> Quiqs Skirmish next
  Defend       :: next -> Quiqs () next
  Me           :: (Ent -> next) -> Quiqs Ent next
  UseAbility   :: R.Ability -> Ent -> (Skirmish -> next) -> Quiqs Skirmish next
  Build        :: Bu.Building -> (Ent -> next) -> Quiqs Ent next
  Move         :: Vec3 -> (Ent -> next) -> Quiqs Ent next
  FaceDir      :: Direction -> (Ent -> next) -> Quiqs Ent next
  EnterBoard   :: Bo.Board -> (Ent -> next) -> Quiqs Ent next
  MkFae        :: Bu.Fae -> (Ent -> next) -> Quiqs Ent next
  GiveCharms   :: Int -> Ent -> next -> Quiqs () next
  WearEquip    :: Equip -> (R.Role -> next) -> Quiqs R.Role next
  deriving (Functor)

data Direction = N | NE | E | SE | S | SW | W | NW
data Skirmish = Skirmish {msg :: String}

data QuiqGame a = Free (Quiqs a ())

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

useAbility :: Ability -> Ent -> QuiqGame Skirmish
useAbility ability target = Free.liftF $ UseAbility ability target ()

build :: Bu.Building -> QuiqGame Ent
build b = Free.liftF $ Build b ()

move :: Vec3 -> QuiqGame R.Ent
move to = Free.liftF $ Move to ()

face :: Direction -> QuiqGame Ent
face dir = Free.liftF $ FaceDir dir ()

enter :: Bo.Board -> QuiqGame Ent
enter board = Free.liftF $ EnterBoard board id

fae :: Bu.Fae -> QuiqGame Ent
fae f = Free.liftF $ MkFae f id

-- use like 3 `charmsTo` friend
charmsTo :: Int -> Ent -> QuiqGame ()
charmsTo n friend = Free.liftF $ GiveCharms n friend ()

wear :: Equip -> QuiqGame R.Role
wear equip = Free.liftF $ WearEquip equip id
