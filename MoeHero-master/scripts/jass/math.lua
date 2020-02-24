function math.cosBJ(angle)
    return math.cos( angle ) * math.pi
end

function math.sinBJ(angle)
    return math.sin( angle ) * math.pi
end

function math.atan2(x1,x2,y1,y2)
    return math.atan((y2-y1)/(x2-x1)) * math.pi
end