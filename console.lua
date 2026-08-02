  playerLocYMin = 50
  playerLocYMax = 200
  playerLocX = 10
  playerLocY = 90
  playerMovement = 10
  playerLane = 1

  chargeMin = 1
  chargeMax = 15
  chargeStatus = 1
  chargeRate = .3
  chargeAmount = chargeMin
  chargeMin = 1
  chargeMax = 15

  energies = {}

  tabletXMin = 100
  tabletXMax = 110
  TalbetYMin = 87
  TabletYDiff = 5
  TabletSpaceBetween = 10  
  
  tablets = {
    {
        name = "tablet1", 
        x = tabletXMin,
        y = TalbetYMin,
        lane = 1,
        age = 0,
        state = stateList["tablet1"]["idle"]
    },
    {
        name = "tablet2",
        x = tabletXMin,
        y = TalbetYMin + TabletSpaceBetween,
        lane = 2,
        age = 0,
        state = stateList["tablet2"]["idle"]
    },
    {
        name = "tablet3",
        x = tabletXMin, 
        y = TalbetYMin + 
        TabletSpaceBetween*2, 
        lane = 3, 
        age = 0,
        state = stateList["tablet3"]["idle"]
    },
    {
        name = "tablet4",
        x = tabletXMin, 
        y = TalbetYMin + TabletSpaceBetween*3, 
        lane = 4, 
        age = 0,
        state = stateList["tablet4"]["idle"]
    } 
  }

function updatePlayer()
  if btnp(2) and playerLane != 1 then 
    playerLocY -= playerMovement 
    playerLane -= 1 
  end
  if btnp(3) and playerLane != 4 then 
    playerLocY += playerMovement 
    playerLane += 1
  end

  if btn(4) then
    chargeStatus = 2
    if(chargeAmount < chargeMax) then
      chargeAmount += chargeRate
    end
  elseif chargeAmount > chargeMin then
    fireCharge()
  end

  if btn(5) then
    local wiz = filterTable(items, function(x) return x.name == "wizard" end)[1]
    wiz.state = deepcopy(stateList["wizard"]["shield"])
  end
end

function drawConsoleState()
  animateTable(tablets)

  circfill(playerLocX,playerLocY, 4, 6)
  circfill(playerLocX+1,playerLocY, 4, 6)
  circfill(playerLocX+1,playerLocY, 3, 0)

  for energy in all(energies) do
    circfill(energy.x,energy.y, 3, 10)
    circfill(energy.x,energy.y, 2, 8)
  end
end

function fireCharge()
    chargeStatus = 1
    add(energies,{
        charge = chargeAmount,
        x=playerLocX,
        y=playerLocY, 
        lane = playerLane
    })
    chargeAmount = chargeMin
end

function updateEnergies()
    for energy in all(energies) do
      if isEnergyComplete(energy) then
        del(energies,energy)
      else 
        energy.x += energy.charge
      end
    end
end

function isEnergyComplete(energy)
  if energy.x >= tabletXMin then
    activateTablet(tablets[energy.lane].lane)
    return true
  end
  return false
end

function activateTablet(ability)
    local wiz = filterTable(items, function(x) return x.name == "wizard" end)[1]
    wiz.state = stateList["wizard"]["jump"]

    if ability == 1 and wiz.row < 5 then
        wiz.row +=1
    elseif ability == 2 and wiz.column < 8 then
        wiz.column += 1
    elseif ability == 3 and wiz.column > 1 then
        wiz.column -= 1
    elseif ability == 4 and wiz.row > 1 then
        wiz.row -=1
  end
end