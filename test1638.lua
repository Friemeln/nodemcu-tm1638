tm = require("tm1638") 

print("setup")
tm.setup()
tm.sendChar(0, "A", false) 
tm.sendChar(1, "B", false)
tm.sendChar(2, "C", true)
tm.sendChar(3, "D", false)
tm.sendChar(4, "E", false)
tm.sendChar(5, "F", false)
tm.sendChar(6, "0", false)
tm.sendChar(7, "1", false)

tm.sendChar(4, "x", 1)

tm.print("  1984  ")

tm.print("")
