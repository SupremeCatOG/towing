Config = {}

Config.whitelist = { -- when adding add-on cars simply use their spawn name
    'FLATBED',
    'BENSON',
    'WASTLNDR', -- WASTELANDER
    'MULE',
    'MULE2',
    'MULE3',
    'MULE4',
    'TRAILER', -- TRFLAT
    'ARMYTRAILER',
    'BOATTRAILER',
}

Config.offsets = { -- when adding add-on cars simply use their spawn name
    {model = 'FLATBED', offset = {x = 0.0, y = -9.0, z = -1.25}}, -- x -> Left/Right adjustment | y -> Forward/Backward adjustment | z -> Height adjustment
    {model = 'BENSON', offset = {x = 0.0, y = 0.0, z = -1.25}},
    {model = 'WASTLNDR', offset = {x = 0.0, y = -7.2, z = -0.9}},
    {model = 'MULE', offset = {x = 0.0, y = -7.0, z = -1.75}},
    {model = 'MULE2', offset = {x = 0.0, y = -7.0, z = -1.75}},
    {model = 'MULE3', offset = {x = 0.0, y = -7.0, z = -1.75}},
    {model = 'MULE4', offset = {x = 0.0, y = -7.0, z = -1.75}},
    {model = 'TRAILER', offset = {x = 0.0, y = -9.0, z = -1.25}},
    {model = 'ARMYTRAILER', offset = {x = 0.0, y = -9.5, z = -3.0}},
}

RampHash = 'imp_prop_flatbed_ramp'
