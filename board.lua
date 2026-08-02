items = {
    {
        row = 1,
        column = 1,
        name = "wizard",
        age = 0,
        state = stateList["wizard"]["start"]
    },
    {
        row = 4,
        column = 4,
        name = "gem",
        age = 0,
        state = stateList["gem"]["idle"]
    }
}

function updateWizard()
    local wiz = filterTable(items, function(x) return x.name == "wizard" end)[1]
    if checkMapCollision(wiz.row, wiz.column, "point") then
        del(items, searchTable(items, "name", "gem"))
        sfx( 0, 0 )
        spawnRate += flr(score/2)
        local randOpenSquare = getRandomOpenSquare()
        add(items, {
            row = randOpenSquare.row,
            column = randOpenSquare.column,
            name = "gem",
            age = 0,
            state = stateList["gem"]["idle"]
        })
        score += 1
    elseif checkMapCollision(wiz.row, wiz.column, "enemy") then 
        gameState = "gameOver"
        return
    end
end

function updateItems()
  for item in all(filterTable(items, function(x) return x.state.name == "remove" end)) do
    del(items, item)
  end

  if #filterTable(items, function(x) return x.name == "flame" end) <= spawnRate then
    if flr(rnd(10)) == 1 then
      local randOpenSquare = getRandomOpenSquare()
      add(items, {
        row = randOpenSquare.row,
        column = randOpenSquare.column,
        name = "flame",
        age = 0,
        state = deepcopy(stateList.flame.spawn)
      })
    end
  end
end


function drawBoardState()
  animateTable(items)
end

function drawToPosition(sprite, row, column)
  local x,y = startingDistance + squareDistance*(column-1),startingDistance + squareDistance*(row-1)
  spr(sprite, x, y)
end

function checkMapCollision(row, column, itemType)
  for item in all(items) do
    if item.row == row and item.column == column and item.state.type == itemType then
      return true
    end
  end
  return false
end

function getRandomOpenSquare()
  local openSquares = {}
  for row=1,5 do
    for column=1,8 do
      if not isOccupied(row,column) then
        add(openSquares,{
          row=row,
          column=column
        })
      end
    end
  end

  if #openSquares == 0 then
    return
  end

  return openSquares[flr(rnd(#openSquares))+1]
end

function isOccupied(row,column)
  for item in all(items) do
    if item.row == row
    and item.column == column then
      return true
    end
  end

  return false
end

