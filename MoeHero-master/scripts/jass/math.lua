function math.cosBJ(angle)
    return math.cos( angle * math.pi/180.0 )
end

function math.sinBJ(angle)
    return math.sin( angle * math.pi/180.0 )
end

function math.atan2(x1,y1,x2,y2)
    -- return math.atan((y2-y1)/(x2-x1)) * (180/math.pi)
    return Atan2((y2-y1),(x2-x1)) * (180/math.pi)
end