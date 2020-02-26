backhome = {}
setmetatable(backhome, backhome)

--结构
local b = {}
backhome.__index = b

-- backhome.defeatdatas = {}
-- backhome.defeatbackdatas = {}
function backhome.find(p)
    for i=1,#backhome do
        if backhome[i].p == p then
            return backhome[i]
        end
    end
    return backhome.create(p)
end

function backhome.create(p,datas,backdatas)
    local self = {}
    self.p = p
    self.datas = datas
    self.backdatas = backdatas
    self.effs = {}
    self.targeteffs = {}
    table.insert( backhome, self )
    setmetatable(self, backhome)
    ac.game.event '回城开始' (function (trg,hero,target)
        self:start(hero,target)
    end)
    ac.game.event '回城结束' (function (trg,hero)
        self:finish(hero)
    end)
    ac.game.event '回城中断' (function (trg,hero)
        self:stop(hero)
    end)
    return self
end

function b:setDatas(datas)
    self.datas = datas
end

function b:setBackDatas(backdatas)
    self.backdatas = backdatas
end

function b:start(hero,target)
    self.target = target
    for i=1,#self.datas do
        if self.datas[i][1] == 'point' then
            local e = effect.create(self.datas[i][2],hero)
            table.insert( self.effs, e )
            local e = effect.create(self.datas[i][2],target)
            table.insert( self.targeteffs, e )
        elseif self.datas[i][1] == 'unit' then
            local e = effect.create_target(self.datas[i][2],hero,self.datas[i][3])
            table.insert( self.effs, e )
            local e = effect.create_target(self.datas[i][2],target,self.datas[i][3])
            table.insert( self.targeteffs, e )
        end
    end
end

function b:stop(hero)
    for i=1,#self.datas do
        self.effs[i]:remove()
        self.targeteffs[i]:remove()
    end
    self.effs = {}
    self.targeteffs = {}
    self.target = nil
end

function b:finish(hero)
    for i=1,#self.backdatas do
        if self.backdatas[i][1] == 'point' then
            effect.create(self.backdatas[i][2],hero):remove()
            effect.create(self.backdatas[i][2],self.target):remove()
        elseif self.backdatas[i][1] == 'unit' then
            effect.create_target(self.backdatas[i][2],hero,self.backdatas[i][3])
        end
    end
    self:stop(hero)
end

function b:isAtBack()
    return self.target
end

function b:destroy()
    if #self.effs > 0 then
        self:stop()
    end
    local key = table.getkey(effect,self)
    table.remove(backdatas,key)
end

local function init()
    for i=1,12 do
        backhome.create(Player(i-1),backhome.datas,backhome.backdatas)
    end
    --回城时有默认的地表图片需要使用空文件覆盖
    --注意西瓦的守护也使用了该贴图
end

init()

