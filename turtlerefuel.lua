print("Welcome to the Turtle Refuel program!")
print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
print("                .-.                  ")
print("                 | \                 ")
print("                 | /\                ")
print("            ,___| |  \               ")
print("           / ___( )   L              ")
print("          '-`   | |   |              ")
print("                | |   F              ")
print("                | |  /               ")
print("                | |                  ")
print("                | |                  ")
print("            ____|_|____              ")
print("           [___________]             ")
print("     ,,,,,/,,,,,,,,,,,,\,,,,,,,,,,,,,")
print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
print("Place fuel in slot 1...")
write("Enter amount of fuel: ")

local input = tonumber(read())
local data = turtle.getItemDetail(1)

while not tonumber(input) do

rint("Please enter a valid number between 1 and 64")

write("Enter amount of fuel: ")

local input = tonumber(read())
local data = turtle.getItemDetail(1)

end
  
turtle.refuel(input) -- refuel turtle with user specified amount of fuel in slot 1

print(string.format("\n Turtle refueled by %s %s" , intinput , data.name))
print("Turtle can move " .. turtle.getfuelLevel() .. " blocks.")

