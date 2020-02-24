jass 	= 	require 'jass.common'
slk	=	require"jass.slk"
japi	=	require'jass.japi'
globals       =	require'jass.globals'
debug	=	require'jass.debug'
message =       require"jass.message"
setmetatable(_ENV, {__index = getmetatable(jass).__index})


print('hellow world')
-- function main ()
--     local std_print = print

--     function print(...)
--         std_print(('[%.2f]'):format(os.clock()), ...)
--     end

--     print 'hello loli!'
--     --print ('package.path = ', package.path)
--     require 'war3.id'
--     require 'war3.api'
--     require 'util.log'
--     require 'ac.init'
--     require 'util.error'
--     local runtime = require 'jass.runtime'
--     if runtime.perftrace then
--         runtime.perftrace()
--         ac.loop(10000, function()
--             log.info('perftrace', runtime.perftrace())
--         end)
--     end
-- end
-- main()
require 'war3.id'
require 'jass.init'

--test
-- local t = timer.create()
-- t:start(2,false,function ()
--     game.display('test')
--     -- t:destroy()
--     -- local e = effect.create([[units\human\Arthas\Arthas.mdl]],0,0)
--     -- e:charge(90,300,3)
--     -- e:destroy(3)
--     local strid = 'A000'
--     local id = base.string2id(strid)
--     game.display(id)
--     game.display(base.id2string(id))
-- end)

print('end world')

jass.FogMaskEnable(false)
jass.FogEnable(false)
