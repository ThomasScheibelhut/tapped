function resetConsole()
  playerLocYMin = 50
  playerLocYMax = 200
  playerLocX = 10
  playerLocY = 94
  playerLane = 1
  shieldJuice = 50
  shieldJuiceGainRate = 3.8
  shieldJuiceLoseRate = .35

  chargeMin = 1
  chargeMax = 15
  chargeStatus = 1
  chargeRate = .3
  chargeAmount = chargeMin
  chargeMin = 1
  chargeMax = 15
  energies = {}

  tabletXMin = 84
  TalbetYMin = 90
  TabletSpaceBetween = 9  
  
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
end

function updatePlayer()
  local wiz = filterTable(items, function(x) return x.name == "wizard" end)[1]

  if btnp(2) and playerLane != 1 then 
    playerLocY -= TabletSpaceBetween 
    playerLane -= 1 
  end
  if btnp(3) and playerLane != 4 then 
    playerLocY += TabletSpaceBetween 
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

  if btnp(5) and wiz.state.name != "shield" and shieldJuice != 0 then
    wiz.state = deepcopy(stateList["wizard"]["shield"])
  elseif btnp(5) and wiz.state.name == "shield" then
    wiz.state = deepcopy(stateList["wizard"]["idle"])
  elseif shieldJuice <= 0 then
    wiz.state = deepcopy(stateList["wizard"]["idle"])
    shieldJuice = 0
  end

  if wiz.state.name == "shield" then
    shieldJuice -= shieldJuiceLoseRate
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

  for i=1, shieldJuice/4, 1 do
	    spr(106,104,114-i, 2,2)
  end
  map(12,11,96,88)
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

    if ability == 1 and wiz.row < 5 then
        wiz.row +=1
        if shieldJuice < 100 then shieldJuice += shieldJuiceGainRate end
    elseif ability == 2 and wiz.column < 8 then
        wiz.column += 1
        if shieldJuice < 100 then shieldJuice += shieldJuiceGainRate end
    elseif ability == 3 and wiz.column > 1 then
        wiz.column -= 1
        if shieldJuice < 100 then shieldJuice += shieldJuiceGainRate end
    elseif ability == 4 and wiz.row > 1 then
        wiz.row -=1
        if shieldJuice < 100 then shieldJuice += shieldJuiceGainRate end
  end
end