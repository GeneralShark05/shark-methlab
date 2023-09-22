# shark-methlab
An advanced meth-making script based on real life methods!

## LICENSE
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.


## Dependencies:
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ultra-voltlab](https://github.com/ultrahacx/ultra-voltlab)

- SonoranCAD (Optional - Change in Config)
- BobIPL (Optional - Change in Config)

## Installation:
1. Add necessary items to ox_inventory/data/items.lua
2. Ensure necessary dependencies before shark-methlab
3. Start shark-methlab

## Items Needed:
['meth_pure'] = {
    label = 'Tray of Pure Meth',
    weight = 750,
    description = 'One tray of Pure Meth'
},

['meth_brick'] = {
    label = 'Bag of Meth',
    weight = 500,
    close = true,
    description = 'One pound bag of Meth',
},

['coughmeds'] = {
    label = 'Cough Medicine',
    weight = 200,
    description = 'A box of high strength cough-medicine.',
    client = {
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = "prop_cs_pills", pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
        usetime = 2500,
        status = { thirst = 10000, drunk = 100000  },
    }
},

['empty_container'] = {
    label = 'Empty Container',
    weight = 500,
    description = 'HDPE Plastic Container',
    stack = true,
},

['plasticwrap'] = {
    label = 'Plastic Wrap',
    weight = 500
},

['fertilizer'] = {
    label = 'Bag of Fertilizer',
    weight = 5000,
    description = 'Dontcha just love the smell?'
},

['acetone'] = {
    label = 'Bottle of Acetone',
    weight = 1000,
    description = 'Great for stains!'
},

['sudo'] = {
    label = 'Container of Pseudoepherine',
    weight = 2500,
    stack = true,
    description = 'Homemade goodness!'
},

['antifreeze'] = {
    label = 'Bottle of Antifreeze',
    weight = 2000,
    description = 'Great for those harsh San Andreas winters!'
},

['sulph'] = {
    label = 'Container of Sulpuric Acid',
    weight = 2500,
    stack = true,
    description = 'Not the best refreshment'
},

['empty_container'] = {
    label = 'Empty Container',
    weight = 500,
    description = 'HDPE Plastic Container',
    stack = false,
},

['phos'] = {
    label = 'Container of Phosphorus',
    weight = 2500,
    stack = true,
    description = 'The Red Menace is among us!'
},

['iodine'] = {
		label = 'Bottle of Iodine',
		weight = 500,
		description = 'Medical Grade Iodine'
},

## Making Meth
Prep Lab First - Valid for 3 Extractions/Cooks
- Pseudoephedrine
Extract Sudo with Cough Meds, Acetone, and Gasoline
- Phosphuric Acid
Steal Sulphuric Acid from the Power Station
Extract Phosphuric Acid with Sulphuric Acid, Fertilizer, and Antifreeze
- Cook Meth
Combine Phosphuric Acid, Sudophedrine, and Iodine to create a tray of unbroken Methamphetamine
Break Methamphetamine with hammer and Plastic Wrap to get a brick/bag of Methamphetamine.

### Thanks to:
- Stachy225 - For providing the snippet of the Meth-Cooking animation.

[Support - Discord](https://discord.gg/mFnNTV2Zce)
