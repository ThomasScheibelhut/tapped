--wizard command 0.1
--#wopedogebo-0#

gameState = "splashScreen"
startingDistance = 5
squareDistance = 16
logging = ""  
holdingButton = false
infinite = -1
songPart = 0

spriteList= {
  gemIdle1 = 21,
  gemIdle2 = 22,
  flameSpawn1 = 23,
  flameSpawn2 = 24,
  flameSpawn3 = 25,
  flameIdle1 = 5,
  flameIdle2 = 4,
  flameIdle3 = 6,
  flameStart1 = 7,
  flameStart2 = 8,
  flameStart3 = 9,
  wizardStart1 = 10,
  wizardStart2 = 10,
  wizardIdle1 = 10,
  wizardIdle2 = 13,
  wizardJump1 = 13,
  wizardJump2 = 14,
  wizardJump3 = 15,
  wizardJump4 = 14,
  wizardJump5 = 13,
  wizardShield1 = 14,
  wizardShield2 = 15,
  tablet1Idle1 = 50,
  tablet1Idle2 = 50,
  tablet2Idle1 = 51,
  tablet2Idle2 = 51,
  tablet3Idle1 = 52,
  tablet3Idle2 = 52,
  tablet4Idle1 = 49,
  tablet4Idle2 = 49
}  

stateList = {
  wizard = {
    start = {
        type = "player",
        name = "start",
        next = "idle",
        loop = 0,
        animation = {
          {name = "wizardStart1", lifeTime = 5}, 
          {name = "wizardStart2", lifeTime = 10}
      } 
    },
    idle = {
        type = "player",
        name = "idle",
        next = "idle",
        loop = infinite,
        animation = {
          {name = "wizardIdle1", lifeTime = 5}, 
          {name = "wizardIdle2", lifeTime = 10}
      } 
    },
    jump = {
        type = "player",
        name = "jump",
        next = "idle",
        loop = 0,
        animation = {
          {name = "wizardIdle1", lifeTime = 1}, 
          {name = "wizardIdle2", lifeTime = 2},
          {name = "wizardIdle2", lifeTime = 1},
          {name = "wizardIdle2", lifeTime = 2},
          {name = "wizardIdle2", lifeTime = 1}
      } 
    },
    shield = {
        type = "player",
        name = "shield",
        next = "idle",
        loop = 400,
        animation = {
          {name = "wizardShield1", lifeTime = 10}, 
          {name = "wizardShield2", lifeTime = 90},
      } 
    }
  },
  gem = {
    idle = {
        type = "point",
        name = "idle",
        next = "idle",
        loop = infinite,
        animation = {
          {name = "gemIdle1", lifeTime = 5}, 
          {name = "gemIdle2", lifeTime = 10}
      } 
    }
  },
  flame = {
    spawn = {
        type = "warning",
        name = "spawn",
        next = "start",
        loop = 8,
        animation = {
          {name = "flameSpawn1", lifeTime = 4},
          {name = "flameSpawn2", lifeTime = 8},
          {name = "flameSpawn3", lifeTime = 12}
      } 
    },
    start = {
        type = "enemy",
        name = "start",
        next = "idle",
        loop = 0,
        animation = {
          {name = "flameStart1", lifeTime = 8},
          {name = "flameStart2", lifeTime = 12},
          {name = "flameStart3", lifeTime = 14}
      } 
    },
    idle = {
        type = "enemy",
        name = "idle",
        next = "despawn",
        loop = 8,
        animation = {
          {name = "flameIdle1", lifeTime = 7 + rnd(3)}, 
          {name = "flameIdle2", lifeTime = 17 + rnd(3)},
          {name = "flameIdle3", lifeTime = 27 + rnd(3)},
      } 
    },
    despawn = {
        type = "warning",
        name = "despawn",
        next = "remove",
        loop = 0,
        animation = {
          {name = "flameSpawn1", lifeTime = 4},
          {name = "flameSpawn2", lifeTime = 8},
          {name = "flameSpawn3", lifeTime = 12},
      } 
    },
    remove = {name = "remove"}
  },
  tablet1 = {
    idle = {
        type = "tablet",
        name = "idle",
        next = "idle",
        loop = infinite,
        animation = {
          {name = "tablet1Idle1", lifeTime = 5}, 
          {name = "tablet1Idle2", lifeTime = 10}
      } 
    }
  },
  tablet2 = {
    idle = {
        type = "tablet",
        name = "idle",
        next = "idle",
        loop = infinite,
        animation = {
          {name = "tablet2Idle1", lifeTime = 5}, 
          {name = "tablet2Idle2", lifeTime = 10}
      } 
    }
  },
  tablet3 = {
    idle = {
        type = "tablet",
        name = "idle",
        next = "idle",
        loop = infinite,
        animation = {
          {name = "tablet3Idle1", lifeTime = 5}, 
          {name = "tablet3Idle2", lifeTime = 10}
      } 
    }
  },
  tablet4 = {
    idle = {
        type = "tablet",
        name = "idle",
        next = "idle",
        loop = infinite,
        animation = {
          {name = "tablet4Idle1", lifeTime = 5}, 
          {name = "tablet4Idle2", lifeTime = 10}
      } 
    }
  }
}

function _init()
end

function _update()
  if gameState == "splashScreen" then
    if btn(4) or btn(5) then
      holdingButton = true
      return
    elseif holdingButton then
      resetGame()
      holdingButton = false
      gameState = "playing"
    end
  elseif gameState == "playing" then
    updatePlayer()
    updateEnergies()
    updateItems()
    updateWizard()
  elseif gameState == "gameOver" then
    music(-1)
    if btn(4) or btn(5) then
      holdingButton = true
      return
    elseif holdingButton then
      sfx( 5, 0)
      holdingButton = false
      gameState = "splashScreen"
    end
    return
  end
end

function resetGame()
  sfx( 5, 0)
  resetBoard()
  resetConsole()
  music(0)
end

function _draw()
  cls()
  if gameState == "splashScreen" then
    drawSplashScreen()
  elseif gameState == "playing" then
    map()
    drawBoardState()
    drawConsoleState()
  elseif gameState == "gameOver" then
    print("game over", 42, 10, 8)
    print("game over", 43, 11, 9)
    print("your score was "..score.."!", 30, 30, 8)
    print("your score was "..score.."!", 31, 31, 9)
    print("press any button to retry", 18, 50, 8)
    print("press any button to retry", 19, 51, 9)
  else
    print("game state: "..gameState)
  end

  print(logging)
end

function drawSplashScreen()
  circfill(75,45, 36, 1)
  circfill(40,60, 22, 2)
  circfill(60,80, 18, 3)
  print("Hello, press any button", 29, 109, 8)
  print("Hello, press any button", 30, 110, 9)
end

function animateTable(table)
    for item in all(table) do
      if item.state.animation then
        if item.age > item.state.animation[#item.state.animation].lifeTime then
          if item.state.loop == 0 then
            item.state = deepcopy(stateList[item.name][item.state.next])
          else
            item.state.loop -= 1
          end
          item.age = 0
        end
        local activeAnimation = filterTable(item.state.animation, function(x) return x.lifeTime >= item.age end)[1]
        if activeAnimation then
          if item.row != nil then
            drawToPosition(spriteList[activeAnimation.name], item.row, item.column)
          else
            spr(spriteList[activeAnimation.name], item.x, item.y)
          end
          item.age += 1
        end
      end
    end
end

function deepcopy(t)
    if type(t) != "table" then
        return t
    end

    local c = {}
    for k,v in pairs(t) do
        c[k] = deepcopy(v)
    end
    return c
end

function searchTable(tbl, field, value)
    for item in all(tbl) do 
        if item[field] == value then
            return item
        end
    end
    return nil
end

--bobs = filterTable(people, function(x) return x.name == "bob" end)
function filterTable(tbl, predicate)
    local results = {}
    for item in all(tbl) do
        if predicate(item) then
            add(results, item)
        end
    end
    return results
end

--add ability to move left
--spawn gems
--spawn enemies
  --cannon
  --spikes
  --flames w/ predictive shadows that fall


