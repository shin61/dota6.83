buff = {}
--系统变量
--进入系统的单位
local units = {}
--已经被注册的bufftype
local bufftypes = {}

function buff.addDefeatBuff(id,datas)
    bufftypes[id].defeatdatas = datas
end

function buff.addBuff(id,datas)
    bufftypes[id].datas = datas
end

local function refreshUnitEffect(handle,effs)
    for id,data in ipair(bufftypes) do
        if GetUnitAbilityLevel(handle,base.string2id(id)) > 0 then
            --有buff
            if not effs[id] then
                --无特效
                data = data.datas or data.defeatdatas
                effs[id] = {}
                for i=1,#data do
                    local e
                    --因为点特效很少用到,默认不写
                    if data[i][1] ~= 'point' then
                        --绑定单位特效
                        --{file,ref}
                        e = effect.create_target(data[i][1],handle,data[i][2])
                    else
                        --点特效
                        --{point,file,angle,立即移除布尔}如果有其他需要依次添加
                        e = effect.create(data[i][2],GetUnitX(handle),GetUnitY(handle),data[i][3])
                    end
                    e.data = data[i]
                    table.insert( effs[id], e )
                end
                
            end
        else
            --无buff
            if effs[id] then
                --有特效
                for _,e in ipair(effs[id]) do
                    if e:getType() == 'point' and e.data[4] then
                        e:immediatelyDestroy()
                    else
                        e:destroy()
                    end
                end
                effs[id] = nil
            end
        end
    end
end


local t = timer.create()
t:start(5,false,function ()
    t:destroy()
    t = timer.create()
    t:start(0.03,true,function ()
        --进行单位遍历
        for _,v in ipair(units) do
            refreshUnitEffect(v.handle,v.effs)
        end
        -- for i=1,#units do
        --     refreshUnitEffect(units[i].handle)
        -- end
    end)
end)