module Game.Quiqs.Building where
-- a structure that can live on a board

data Building =
              -- 0 way wall
                Blockade {}
              -- one way wall
              | Scaffold {}
              -- battle tower
              | Turret {}
              -- water battle tower
              | Floatament {}
              -- water transport
              | Ship {}
              -- observation tower
              | Mirador {}
              -- building housing a dipolomat
              | Chancery {}
              -- summonry tower
              | Steeple {summoned :: Golem }
              -- home base
              | Keep {}
              -- produces charms for power
              | Charmery {}

data Fae =
           -- destroys land buildings
             Disir
           -- destroys water buildings and other water golems
           | Kelpie
           -- destroys Keeps
           | Suileach
           -- carries charms and can construct buildings
           | Leprechaun
           -- destroys golems
           | Barguest
           -- destroys combatants
           | Dullahan
