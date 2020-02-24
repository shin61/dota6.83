--[[<?
local open = io.__open
if open==nil then
    open=io.open
end
require 'mpq_util'
f=open("script/ydwe/compile/jasshelper.lua","r")
s=f:read("*a")
f:close()]]
--s=string.gsub(s,'local parameter = ""',[[ 
--        local parameter = ""
--        require "compile.cjass"
--        cjass:do_compile(map_path, option)
--        jasshelper.compile=nil
--]])
--[[f=open("script/ydwe/template2.lua","w")
f:write(s)
f:close()
package.loaded["template2"]=nil
require "template2"
?>]]
--在YDWE才有用
 