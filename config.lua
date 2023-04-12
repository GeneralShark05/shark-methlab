Config = {}

Config.Debug = false
Config.ItemDebug = false
Config.SonoranCAD = true

----------------------------------------------------------------------------
-- Labs --
----------------------------------------------------------------------------

Config.labs = {
	[1] = {
		cookTarget = {1005.7503662109, -3200.8913574219, -38.209575653076}, cookAnim = {1005.773, -3200.402, -38.524}, cookH = 180.0, -- Cooking
		hammerTarget = {1012.2446289063, -3194.1000976563, -39.192222595215}, hammerRotate = 0, hammerAnim = {1012.0938, -3194.8188, -38.9931}, hammerH = 360.0, -- Breaking Table
		prepTarget = {1006.8984985352, -3197.7546386719, -38.5}, prepRotate = 355, -- Control Panel
		cookState = 0, prepState = 0, count = 0 -- Dont change unless you want to be castrated
	},
}

Config.cheapMeth = { -- Location of the worse, more easily accessible meth
	animCoords1 = {1391.8817, 3605.8767, 38}, animHeading1 = 103.0970, targetCoords1 = {1391, 3605.5710, 38.9}, -- Sudo
	animCoords2 = {1389.7385, 3603.3762, 38}, animHeading2 = 292.2780, targetCoords2 = {1390.50, 3603.8, 38.9418} -- Meth
}