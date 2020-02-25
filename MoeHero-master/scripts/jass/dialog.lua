local dialog = {}
setmetatable(dialog, dialog)

--结构
local d = {}
dialog.__index = d

local function init(text)
    local d = {}
    table.insert(dialog,d)
    setmetatable(dialog,d)
    --实例化
    d.handle = DialogCreate()
    DialogSetMessage(d.handle,text or '')
    --btn数据集
    d.data = {}
    d.click = CreateTrigger()
    TriggerRegisterDialogEvent(d.click,d.handle)
    TriggerRegisterAddAction(d.click,function ()
        local btn = GetClickedButton()
        local id = GetHandleId(btn)
        local code = d.data[id].code
        if code then
            code()
        end
    end
    )
    return d
end

function d:addButton(text,code,key)
    local data = self.data
    local btn = DialogAddButton(self.handle,text,base.string2id(key) or 0)
    local id = GetHandleId(btn)
    data[id] = {}
    data[id].code = code
    data[id].text = text
end

function d:display(p)
    if GetLocalPlayer() == p or GetLocalPlayer() then
        DialogDisplay(GetLocalPlayer(),self.handle,true)
    end
end

function d:destroy(time)
    local t = timer.create()
    local destroy = function()
        DialogDisplay(GetLocalPlayer(),self.handle,false)
        DialogClear(self.handle)
        DialogDestroy(self.handle)
        DestroyTrigger(self.click)
        for i=1,#dialog do
            if dialog[i] == self then
                table.remove(dialog,i)
                break
            end
        end
        t:destroy()
    end
    t:start(time or 0,false,destroy)
end

function dialog.create(text)
    return init(text)
end

return dialog