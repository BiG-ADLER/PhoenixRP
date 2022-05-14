radioConfig = {
    Controls = {
        Activator = { -- Open/Close Radio
            Name = "INPUT_CELLPHONE_CANCEL", -- Control name
            Key = 177, -- BackSpace
        },
        Secondary = {
            Name = "INPUT_SPRINT",
            Key = 21, -- Left Shift
            Enabled = false, -- Require secondary to be pressed to open radio with Activator
        },
        Toggle = { -- Toggle radio on/off
            Name = "INPUT_CONTEXT", -- Control name
            Key = 51, -- E
        },
        Increase = { -- Increase Frequency
            Name = "INPUT_CELLPHONE_RIGHT", -- Control name
            Key = 175, -- Right Arrow
            Pressed = false,
        },
        Decrease = { -- Decrease Frequency
            Name = "INPUT_CELLPHONE_LEFT", -- Control name
            Key = 174, -- Left Arrow
            Pressed = false,
        },
        Input = { -- Choose Frequency
            Name = "INPUT_FRONTEND_ACCEPT", -- Control name
            Key = 201, -- Enter
            Pressed = false,
        },
        Broadcast = {
            Name = "INPUT_VEH_PUSHBIKE_SPRINT", -- Control name
            Key = 137, -- CapsLock
        },
        ToggleClicks = { -- Toggle radio click sounds
            Name = "INPUT_SELECT_WEAPON", -- Control name
            Key = 37, -- Tab
        }
    },
    Frequency = {
        Private = { -- List of private frequencies
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true,
        [6] = true,
        [7] = true,
        [8] = true,
        [9] = true,
        [10] = true,
        [11] = true,
        [12] = true,
        [13] = true,
        [14] = true,
        [15] = true,
        [16] = true,
        [17] = true,
        [18] = true,
        [19] = true,
        [20] = true
        }, -- List of private frequencies
        Current = 1, -- Don't touch
        CurrentIndex = 1, -- Don't touch
        Min = 1, -- Minimum frequency
        Max = 1000, -- Max number of frequencies
        List = {}, -- Frequency list, Don't touch
        Access = {}, -- List of freqencies a player has access to
    },
    AllowRadioWhenClosed = true -- Allows the radio to be used when not open (uses police radio animation) 
}

SI = {
    PrivateFrequency = {
        ["police"] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15},
        ["sheriff"] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15},
        ["dadgostari"] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20},
        ["ambulance"] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15},
    }
}

for k,v in pairs(SI.PrivateFrequency) do
    for _,v2 in pairs(v) do
        radioConfig.Frequency.Private[v2] = true
    end
end