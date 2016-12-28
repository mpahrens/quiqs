
module Game.Quiqs.Role where

-- represents the playable character
data Role = Role { name   :: String
                 , attack :: Int
                 , defense :: Int
                 , equipped :: [Equip]
                 , rStyle :: Style
                 , abilities :: [Ability]}

data Equip = Head String [Effect]
           | Body String [Effect]
           | Legs String [Effect]
           | Feet String [Effect]
           | MainWeapon String [Effect]
           | SubWeapon String [Effect]

data Effect = AttackMod Int
            | DefenseMod Int
            | AccuracyMod Int
            | Damage {dmg :: Int, dist :: Int, style :: Style}
            | Block Int

data Style = Slash | Pierce | Magic

data Guild = Guild { gName :: String
                   , gExp :: Int
                   , founder :: String}

data Ability
