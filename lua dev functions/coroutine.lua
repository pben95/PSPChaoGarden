corutinas.lua

function func_a(valor_inicial)
 for i=1, 10 do
 coroutine.yield("A", i, valor_inicial+i);
 end
end
function func_b (valor_inicial)
 for i=1,5 do
 coroutine.yield("B", i, valor_inicial+i);
 end
end
usb:on(); --Inicio del programa:
co1 = coroutine.create( func_a );
fu2 = coroutine.wrap( func_b );
tempfile = io.open( "tempf.txt" , "w" );
while coroutine.status(co1)~="dead" do
res, co, num, val = coroutine.resume( co1 , 3 );
tempfile:write( res , co , num , val , "\n" );
co, num, val = fu2( 5 );
tempfile:write( co , num , val , "\n" );
end
tempfile:flush();
tempfile:close();
-- // Salida obtenida:
-- // true A 1 4
-- // B 1 6
-- // true A 2 5
-- // B 2 7
-- // true A 3 6
-- // B 3 8
-- // true A 4 7
-- // B 4 9
-- // true A 5 8
-- // B 5 10
-- // true A 6 9
-- // nil nil nil
-- // true A 7 10
-- // ERROR! cannot resume dead coroutine
