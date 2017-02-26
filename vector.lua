local Vector = {}
do
    local meta = {
        _metatable = "Private metatable",
        _DESCRIPTION = "Vectors in 2D"
    }

    meta.__index = meta

    function meta:__add(v)
        return Vector(self.i + v.i, self.j + v.j)
    end

    function meta:__sub(v) 
        return Vector(self.i - v.i, self.j - v.j)
    end

    function meta:__mul(v)
        return self.i * v.i + self.j * v.j
    end

    function meta:unit()
      return Vector(self.i / self:len(), self.j / self:len())
    end

    function meta:copy()
      return Vector(self.i, self.j)
    end

    function meta:scalar_mul(v)
      return Vector(self.i * v, self.j * v) 
    end

    function meta:div(v)
      return Vector(self.i / v, self.j / v)
    end

    function meta:__tostring()
        return ("<%g, %g>"):format(self.i, self.j)
    end

    function meta:len()
        return math.sqrt( self * self )
    end

    setmetatable( Vector, {
        __call = function( V, i ,j ) return setmetatable( {i = i, j = j}, meta ) end
    } )
end

Vector.__index = Vector

return Vector
