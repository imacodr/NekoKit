local Packages = game.ReplicatedStorage.Packages

local Neko = require(Packages.NekoKit)

local bond = Neko.Bond("boom", {
	["test"] = "test",
})

print(bond.Id)

local app = bond:New("Frame")({
	Size = UDim2.new(0, 100, 0, 100),
	BackgroundColor3 = Color3.fromRGB(255, 0, 0),
})
