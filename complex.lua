-- http://www.tutorialspoint.com/lua/lua_metatables.htm
-- http://www.root.cz/clanky/objektove-orientovane-programovani-v-lua-ii/

Complex = {}
Complex.__index = Complex
Complex.__call = function(_, ...) return Complex:new(...) end
setmetatable(Complex, Complex)

function Complex:new(real, imag)
	print("Create", real, imag)
	local complex = {real = real, imag = imag}
	--return setmetatable({real = real, imag = imag}, self)
	return setmetatable(complex, self)
end

function Complex:_new(real, imag)
	local complex = setmetatable({}, self)
	complex.real = real
	complex.imag = imag
	return complex
end

function Complex:add(other)
	self.real = self.real + other.real
	self.imag = self.imag + other.imag
end

function Complex.__add(lhs, rhs)
	return Complex:new(lhs.real + rhs.real, lhs.imag + rhs.imag)
end

function Complex.__tostring(self)
	if (self.imag < 0) then
		return self.real .. self.imag .. "i"
	else
		return self.real .. "+" .. self.imag .. "i"
	end	
end

function Complex:print()
	print(self)
end

c1 = Complex:new(1.17, 2.98765)
c2 = Complex(3, -4)

print('c1', c1)
print('c2', c2)

c1:add(c2)

print('c1', c1)
print('c2', c2)

c3 = c1 + c2

print('c3', c3)
