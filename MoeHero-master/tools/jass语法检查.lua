require 'filesystem'
local root = fs.path(arg[1])
local cj=root/'tools'/'jasshelper'/'scripts'/'common.j'
local bj=root/'tools'/'jasshelper'/'scripts'/'blizzard.j'
local jh=root/'tools'/'jasshelper'/'jasshelper.exe'
local script = root / 'map'/ 'war3map'
local s1="--scriptonly"
local s2="--scriptonly --nopreprocessor"
local watch = arg[2] == '--watch'
-- 使用JassHelper编译地图 默认用新版pjass
-- jh_path - jasshelper.exe路径
-- common_j_path - common.j路径
-- blizzard_j_path - blizzard.j路径
-- map_path - 地图路径
function jasshelper(jh_path,common_j_path,blizzard_j_path,map_path)			  
            local temp=''
            if not watch then
                temp=s1
                print('jass编译不会自动清除war3map.vj')
            else
                temp=s2
            end
            -- 生成命令行
            local command_line = string.format('"%s %s %s %s %s.j "%s.vj"',
                    jh_path,
                    temp,
                    common_j_path,
                    blizzard_j_path,
                    map_path,
                    map_path
                )
                --print(command_line)
                return os.execute(command_line)
end
local b=jasshelper(jh,cj,bj,script)
if(b==true and watch)then
    local temp=root / 'map'/ 'war3map.vj'
    -- 语法检查时生成命令行删除自动生成的war3map.vj
    local command = string.format('"del /q %s"',temp)
    os.execute(command)
end