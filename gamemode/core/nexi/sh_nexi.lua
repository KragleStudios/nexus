local meta = FindMetaTable("Player")

function meta:getNexi()
	if (CLIENT and self.Nexi != self:GetNWInt("Nexi", 0)) then
		self.Nexi = self:GetNWInt("Nexi", 0)
	end

	return self.Nexi
end

function meta:canAfford(iAmt)
	iAmt = tonumber(iAmt)

	local nexi = self:getNexi()

	if ((nexi - iAmt) >= 0) then return true end
	
	return false
end

if (CLIENT) then return end
util.AddNetworkString("Nexi_Load")

function meta:syncNexi()
	self:SetNWInt("Nexi", self.Nexi)
end

function meta:loadNexi()
	self.Nexi = self:GetPData("Nexi", 0)
	self:SetNWInt("Nexi", self.Nexi)
end

function meta:addNexi(iAmt)
	iAmt = tonumber(iAmt)

	self.Nexi = self.Nexi + iAmt
	self:syncNexi()
end

function meta:takeNexi(iAmt)
	iAmt = tonumber(iAmt)

	self.Nexi = self.Nexi - iAmt
	self:syncNexi()
end

function meta:setNexi(iAmt)
	iAmt = tonumber(iAmt)

	self.Nexi = iAmt
	self:syncNexi()
end
