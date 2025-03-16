local Packages = game.ReplicatedStorage.Packages

local Neko = require(Packages.NekoKit)

local bond = Neko.Bond("boom", {
	["test"] = Color3.fromRGB(255, 0, 0),
})

print(bond.Id)
print(bond.Theme)

bond:LoadLib(script.CoolLib)

bond:New("Frame")({
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 100, 0, 100),
	BackgroundColor3 = "test",
})

bond:New("Box")({
	Size = UDim2.new(0, 200, 0, 100),
	BackgroundColor3 = "Sigma",
})
