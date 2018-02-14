
-- User Config ////////////////////
store_items_in_chest = false -- Change this to true if you want the turtle to place items in a chest below it after returning home.
is_refuelable = true -- Change this to true if you want the turtle to check every slot for fuel after fuel runs out.
return_home = true -- Change to false if you don't want the turtle to return to starting point.
movement_length = 3 -- Square size of tunnel. ex: movement_length of 3 means 3x3 square tunnel, movement_length of 5 means 5x5, etc..
diamonds_reported = true -- Progress report will show number of diamonds mined.
iron_reported = true -- Progress report will show number of ores of iron mined.
tunnel_style = "Across" -- This should be "Across" , "Down" , "Diagonal" ---- Not Implemented :(
-- ////////////////////////////

-- Setting variables for reports -- 
iron_found = 0 -- ignore
diamonds_found = 0 -- ignore
blocks_mined = 0 -- ignore
blocks_undetected = 0 -- ignore
tunnel_length = 0 -- ignore
fuel_added = 0 -- ignore
-- -- -- -- -- -- -- -- -- -- -- --

function round(n)
  return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function CheckForItem(item)

  local success, data = turtle.inspect()
  
  if success and data.name == item then
    return true
  else
    return false
  end
      
end

function StoreItems()
  
rednet.broadcast("Storing items..")
 
  for i = 1,16 do
    turtle.select(i)
    turtle.dropDown()
  end
  
rednet.broadcast("All items stored!")
rednet.broadcast()

end

function FuelExists()

rednet.broadcast("Checking for fuel...")
  
-- If user sets is_refueled = true, every slot will be checked for valid fuel and that fuel will be consumed.
  for i = 1, 16 do
    turtle.select(i)

      if turtle.refuel() then
        rednet.broadcast("Fuel found in slot " .. turtle.getSelectedSlot() .. ".")
        fuel_added = turtle.getFuelLevel()
        return true
      end
  end
  return false
end

function ReturnHome(up)

rednet.broadcast("---------------")
rednet.broadcast("Returning Home ")
rednet.broadcast("---------------")
  
  if up then
  
   TurtleRotate180()
  
   for i = 1, tunnel_length do
      TryDig("Forward")
   end 
   
   TurtleRotate180()
    
  else 
  
    for i = 1, movement_length - 1 do
      TryDig("Down")
    end
    
    turtle.turnRight()
    
    for i = 1, movement_length - 1 do
      TryDig("Forward")
    end
    
    turtle.turnRight()
    
    for i = 1, tunnel_length do
      TryDig("Forward")
    end 
    
    TurtleRotate180()
      
  end
      
  if store_items_in_chest then
    StoreItems()
  end
  
end

function MineArrayAcross()
  
  up = true
  
  while turtle.getFuelLevel() > tunnel_length + (movement_length * movement_length) + (movement_length * 2) do
  
    TryDig("Forward")
    
    if up then
      turtle.turnLeft()
    else 
      turtle.turnRight()
    end   
    
    for i = 1, movement_length do
      for j = 1, movement_length - 1 do
        TryDig("Forward")
      end
        if i ~= movement_length then
          if up then
            TryDig("Up")
          else
            TryDig("Down")
          end
          TurtleRotate180() 
        end
    end
    
    tunnel_length = tunnel_length + 1
    
    up = not up
    
    if up then
      turtle.turnLeft()
    else 
      turtle.turnRight()
    end
    SendReport()
  end 
  return up
end

function TurtleRotate180()
  turtle.turnLeft()
  turtle.turnLeft()
end

function TryDig(direction)

  if direction == "Up" then
    if turtle.detectUp() then
    
      if diamonds_reported and CheckForItem("minecraft:diamond_ore") then
        diamonds_found = diamonds_found + 1
      end
        
      if iron_reported and CheckForItem("minecraft:iron_ore") then
        iron_found = iron_found + 1
      end
          
      turtle.digUp()
      blocks_mined = blocks_mined + 1
    else
      blocks_undetected = blocks_undetected + 1    
    end
    
    turtle.up()  
  
  elseif direction == "Down" then
    if turtle.detectDown() then
    
      if diamonds_reported and CheckForItem("minecraft:diamond_ore") then
        diamonds_found = diamonds_found + 1
      end
        
      if iron_reported and CheckForItem("minecraft:iron_ore") then
        iron_found = iron_found + 1
      end
          
      turtle.digDown()
      blocks_mined = blocks_mined + 1
    else
      blocks_undetected = blocks_undetected + 1  
    end  
    
    turtle.down()
    
  elseif direction == "Forward" then
    if turtle.detect() then
    
      if diamonds_reported and CheckForItem("minecraft:diamond_ore") then
        diamonds_found = diamonds_found + 1
      end
      
      if iron_reported and CheckForItem("minecraft:iron_ore") then
        iron_found = iron_found + 1
      end
          
      turtle.dig()
      blocks_mined = blocks_mined + 1
    else
      blocks_undetected = blocks_undetected + 1  
    end  
    
    turtle.forward()
    
  end
end

function SendReport()

local fuel_efficiency = (blocks_mined - blocks_undetected) / blocks_mined * 100
local fuel_left = turtle.getFuelLevel() / fuel_added * 100

-- Send report to wirelessly available computer 
rednet.broadcast("|---------------------------|")
rednet.broadcast("|------Progress Report------|")
rednet.broadcast("|---------------------------|")
rednet.broadcast(string.format("|Tunnel Length         : %s    " , tunnel_length))
rednet.broadcast(string.format("|Moves Remaining       : %s    " , turtle.getFuelLevel()))
rednet.broadcast(string.format("|Fuel Remaining        : %s%%   " , round(fuel_left)))

  if round(fuel_efficiency) <= 0 then
    rednet.broadcast(string.format("|Fuel Efficiency       : Not Productive Yet    " , round(fuel_efficiency)))
  else
    rednet.broadcast(string.format("|Fuel Efficiency       : %s%%    " , round(fuel_efficiency)))
  end

  if diamonds_reported then
    rednet.broadcast(string.format("|Diamonds Found        : %s    " , diamonds_found))
  end

  if iron_reported then
    rednet.broadcast(string.format("|Iron Found            : %s    " , iron_found))
  end
              rednet.broadcast("|---------------------------|")
  
end

function SendCompletedReport()

local fuel_efficiency = (blocks_mined - blocks_undetected) / blocks_mined * 100

rednet.broadcast("|----------------------------|")
rednet.broadcast("|------Completed Report------|")
rednet.broadcast("|----------------------------|")
rednet.broadcast(string.format("|-Mined a total of %s blocks-|" , blocks_mined))
rednet.broadcast(string.format("|----At efficiency of %s%%---|" , round(fuel_efficiency)))
rednet.broadcast("|     Mining Completed       |")
rednet.broadcast("| Returned Home Successfully |")
rednet.broadcast("|----------------------------|")

end

function StartUp()
  print("|Turtle Starting up.......|")
  print("|Array Size       : " , movement_length)
  print("|Return Home      : " , return_home)
  print("|Item to Chest    : " , tostring(store_items_in_chest))
  print("|Refuels Passively: " , tostring(is_refuelable))
  print("|Diamonds Reported: " , tostring(diamonds_reported))
  print("|Iron Reported: " , tostring(iron_reported))
  print("|Beginning Mining.........|")
  
end

local function main()

rednet.open("left")
StartUp()

  if (turtle.getFuelLevel() > math.pow(movement_length , 2)) or turtle.refuel() then
      
    fuel_added = turtle.getFuelLevel()
    next_direction_is_up = MineArrayAcross()
    
    while is_refuelable and FuelExists() do
      next_direction_is_up = MineArrayAcross()
    end
    
    if return_home then
      ReturnHome(next_direction_is_up)
    end
  
  else
    print("Not enough fuel - Please place fuel in slot 1 :)")
  end
  
SendCompletedReport()
turtle.select(1)

end

main()

