sound = {}
setmetatable(sound, sound)

--结构
local s = {}
sound.__index = s

function sound.play(file)
    local self = sound.find(file)
    StartSound(self.handle)
    KillSoundWhenDone(self.handle)
    return self
end

function sound.playByName(name)
    local self = sound.findByName(name)
    if self then
        StartSound(self.handle)
        KillSoundWhenDone(self.handle)
    end
end

function sound.find(file)
    for i=1,#sound do
        if sound[i].file == file then
            return sound[i]
        end
    end
    return sound.create(file)
end

function sound.findByName(name)
    for i=1,#sound do
        if sound[i].name == name then
            return sound[i]
        end
    end
    return nil
end

function sound.create(file,name)
    local self = {}
    setmetatable(self, sound)
    table.insert(sound,self)
    self.handle = CreateSound(file, false, false, true, 12700, 12700, "")
    -- SetSoundChannel(self.handle, 0)
    self:setVolume(100)
    SetSoundPitch(self.handle, 1)
    self.name = name
    return self
end

--3D音效需要单声道
function sound.create3D(file,range)
    range = range or 2000
    local self = {}
    setmetatable(self, sound)
    table.insert(sound,self)
    self.handle = CreateSound(file, false, false, true, range, range + 1000, "")
    -- SetSoundChannel(self.handle, 0)
    self:setVolume(100)
    SetSoundPitch(self.handle, 1)
    self.range = range
    return self
end

--设置声音大小
--取值0 - 100
function s:setVolume(file,size)
    SetSoundVolume(self.handle, size/1.27)
end

function s:play3D(x,y)
    if x and y then
        SetSoundPosition(self.handle,x,y)
    end
    self:play()
end

function s:play(p)
    if p or GetLocalPlayer() == GetLocalPlayer() then
        StartSound(self.handle)
        KillSoundWhenDone(self.handle)
    end
end

--[马上停止]
function s:stop(fadeOut)
    StopSound(self.handle, false, fadeOut)
end