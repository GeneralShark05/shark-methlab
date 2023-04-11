Config = {}

-- Debug Settings
Config.Debug = false
Config.ItemDebug = false

-- Enable SonoranCAD Alerts
Config.SonoranCAD = true

-- Alert Chances
Config.StealChance = 3 -- 1/3 Chance of alerting police when stealing Acid
Config.BuyChance = 2 -- 1/2 Chance of alerting police when buying bulk
Config.BuyAmount = 4 -- Buying more than 4 at once triggers the alert
-- Cook Settings
Config.CookTime = 80000 -- Length it takes to complete a normal cook
Config.CookReward = 10 -- Trays of Meth from 1 Cook
Config.CookSudo = 5

Config.CheapCookTime = 20000 -- Length it takes to complete a cheap cook
Config.CheapReward = 1
Config.CheapSudo = 3

-- Locations
Config.labs = { -- Privately controlled labs, fair warning, Changing the headings of cookH and hammerH does some wacky shit.
	[1] = { -- bobipl Lab
		cookTarget = {1005.7503662109, -3200.8913574219, -38.209575653076}, cookAnim = {1005.773, -3200.402, -38.524}, cookH = 180, -- Cooking
		hammerTarget = {1012.2446289063, -3194.1000976563, -39.192222595215}, hammerRotate = 0, hammerAnim = {1012.0938, -3194.8188, -38.9931}, hammerH = 0, -- Breaking Table
		prepTarget = {1006.8984985352, -3197.7546386719, -38.5}, prepRotate = -5, -- Control Panel
		cookState = 0, prepState = 0, count = 0 -- Dont change unless you want to be castrated
	},
}

Config.cheapMeth = { -- Location of the worse, more easily accessible meth
	animCoords1 = {1391.8817, 3605.8767, 38}, animHeading1 = 103.0970, targetCoords1 = {1391, 3605.5710, 38.9}, -- Sudo
	animCoords2 = {1389.7385, 3603.3762, 38}, animHeading2 = 292.2780, targetCoords2 = {1390.50, 3603.8, 38.9418} -- Meth
}