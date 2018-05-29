strings.lua
-- STRING.GSUB
x = string.gsub("hola mundo", "(%w+)", "%1 %1")
-->
x="hola hola mundo mundo"
s = "hola mundo";
x = s:gsub("hola mundo", "%w+", "%0 %0", 1)
-->
x="hola hola mundo"
x = string.gsub("hola mundo desde Lua", "(%w+)%s*(%w+)", "%2 %1")
-->
x="mundo hola Lua desde"
x = string.gsub("4+5 = $return 4+5$", "%$(.-)%$", function(s) return loadstring(s)() end)
-->
x="4+5 = 9"
local t = {nombre="lua", versión="5.1"}
x = string.gsub("$nombre-$versión.tar.gz", "%$(%w+)", t)
-->
x="lua-5.1.tar.gz"
