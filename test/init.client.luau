local Packages = game.ReplicatedStorage.Packages

local Neko = require(Packages.NekoKit)

local bond = Neko.Bond("boom", {
	["test"] = Color3.fromRGB(255, 0, 0),
})

print(bond.Id)
print(bond.Theme)

bond:New("Frame")({
	Size = UDim2.new(0, 100, 0, 100),
})
