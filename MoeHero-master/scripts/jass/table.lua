--return 排序位置
function table.getkey(t,vaule)
    for i=1,#t do
        if t[i] == vaule then
            return i
        end
    end
    return 0
end

function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end