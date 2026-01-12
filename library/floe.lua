-- SCC Taiko Drums v1.0 is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
-- https://www.schristiancollins.com
-- Original samples by Subaqueous: http://subaqueousmusic.com/free-taiko-drum-rack/
--
-- This file is a translation of the SFZ instrument into Floe's Lua format with various modifications.
-- This file is also licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
-- https://creativecommons.org/licenses/by-sa/4.0/
-- Copyright Sam Windell 2026

floe.set_required_floe_version("1.1.1")

local library = floe.new_library({
    name = "SCC Taiko Drums",
    tagline = "Simple multisampled taiko drums",
    description =
    "A free multisampled Japanese taiko drum library with multiple velocity layers and round-robin samples. Each drum is triggered by a pair of adjacent keys (white + black) for easy drum rolls via trills. A great starting point for taiko percussion. This is a slightly modified version of S. Christian Collins' SCC Taiko Drums v1.0. This port was made by the Floe team.",
    author = "Floe Ports",
    author_url = "https://www.schristiancollins.com",
    library_url = "https://github.com/Floe-Project/SCC-Taiko-Drums",
    minor_version = 1,
    background_image_path = "Images/Taiko_Pratice_in_Toba_(2629215936).jpg",
    icon_image_path = "Images/icon.png",
})

floe.set_attribution_requirement("Samples", {
    title = "SCC Taiko Drums v1.0",
    license_name = "CC-BY-SA-4.0",
    license_url = "https://creativecommons.org/licenses/by-sa/4.0/",
    attributed_to = "S. Christian Collins (programming), Subaqueous (samples)",
    attribution_url = "https://www.schristiancollins.com",
})

floe.set_attribution_requirement("Images/Taiko_Pratice_in_Toba_(2629215936).jpg", {
    title = "Taiko Practice in Toba",
    license_name = "CC-BY-2.0",
    license_url = "https://creativecommons.org/licenses/by/2.0/",
    attributed_to = "syvwlch",
    attribution_url = "https://commons.wikimedia.org/wiki/File:Taiko_Pratice_in_Toba_(2629215936).jpg",
})

local function add_drum(instrument, config)
    floe.add_named_key_range(instrument, {
        name = config.name,
        key_range = config.key_range,
    })

    local rr_group_counter = 0

    for _, layer in ipairs(config.layers) do
        local samples = layer.samples

        if type(samples) == "string" then
            samples = { samples }
        end

        local is_round_robin = #samples > 1
        local rr_group_name = nil

        if is_round_robin then
            rr_group_counter = rr_group_counter + 1
            local key_name = string.format("k%d", config.root_key)
            rr_group_name = string.format("%s_rr%d", key_name, rr_group_counter)
        end

        for idx, sample_path in ipairs(samples) do
            local region_config = {
                path = sample_path,
                root_key = config.root_key,
                trigger_criteria = {
                    key_range = config.key_range,
                },
                playback = { keytrack_requirement = "never" },
            }

            if layer.velocity_range then
                region_config.trigger_criteria.velocity_range =
                    floe.midi_range_to_hundred_range(layer.velocity_range)
            end

            if is_round_robin then
                region_config.trigger_criteria.round_robin_index = idx - 1
                region_config.trigger_criteria.round_robin_sequencing_group = rr_group_name
            end

            if layer.gain_db then
                region_config.audio_properties = {
                    gain_db = layer.gain_db,
                }
            end

            if layer.loop_requirement then
                region_config.loop = {
                    loop_requirement = layer.loop_requirement,
                }
            end

            floe.add_region(instrument, region_config)
        end
    end
end

local taiko = floe.new_instrument(library, {
    name = "SCC Taiko Drums",
    description =
    "Japanese taiko drums with multiple velocity layers and round-robin samples. Play trills on adjacent key pairs for realistic drum rolls.",
    tags = { "taiko", "drums", "percussion", "japanese", "acoustic", "ethnic" },
})

-- C2-C#2: Taiko Drum 1 (round-robin)
add_drum(taiko, {
    name = "Taiko Drum 1",
    key_range = { 36, 38 },
    root_key = 36,
    layers = {
        {
            velocity_range = { 1, 74 },
            samples = {
                "Samples/Taiko Drum Hit 1-15.flac",
                "Samples/Taiko Drum Hit 1-16.flac",
            },
        },
        {
            velocity_range = { 75, 127 },
            samples = {
                "Samples/Taiko Drum Hit 1-27.flac",
                "Samples/Taiko Drum Hit 1-28.flac",
                "Samples/Taiko Drum Hit 2-6.flac",
            },
        },
    },
})

-- D2-D#2: Taiko Drum 2 (round-robin)
add_drum(taiko, {
    name = "Taiko Drum 2",
    key_range = { 38, 40 },
    root_key = 38,
    layers = {
        {
            velocity_range = { 1, 74 },
            samples = {
                "Samples/Taiko Drum Hit 2-2.flac",
                "Samples/Taiko Drum Hit 1-25.flac",
            },
        },
        {
            velocity_range = { 75, 104 },
            samples = {
                "Samples/Taiko Drum Hit 1-18.flac",
                "Samples/Taiko Drum Hit 2-7.flac",
            },
        },
        {
            velocity_range = { 105, 127 },
            samples = "Samples/Taiko Drum Hit 2-5.flac", -- SFZ has amp_veltrack=100 (not supported)
        },
    },
})

-- F2-F#2: Taiko Drum 1-high
add_drum(taiko, {
    name = "Taiko Drum 1-high",
    key_range = { 41, 43 },
    root_key = 41,
    layers = {
        { velocity_range = { 1, 49 },   samples = "Samples/Taiko Drum Hit 1-23.flac" },
        { velocity_range = { 50, 92 },  samples = "Samples/Taiko Drum Hit 1-19.flac" },
        { velocity_range = { 93, 127 }, samples = "Samples/Taiko Drum Hit 1-17.flac" },
    },
})

-- G2-G#2: Taiko Drum 2-high
add_drum(taiko, {
    name = "Taiko Drum 2-high",
    key_range = { 43, 45 },
    root_key = 43,
    layers = {
        { velocity_range = { 1, 38 },    samples = "Samples/Taiko Drum Hit 2-4.flac" },
        { velocity_range = { 39, 69 },   samples = "Samples/Taiko Drum Hit 2-0.flac" },
        { velocity_range = { 70, 99 },   samples = "Samples/Taiko Drum Hit 2-1.flac" },
        { velocity_range = { 100, 127 }, samples = "Samples/Taiko Drum Hit 2-3.flac" },
    },
})

-- A2-A#2: Taiko Drum 3
add_drum(taiko, {
    name = "Taiko Drum 3",
    key_range = { 45, 47 },
    root_key = 45,
    layers = {
        { velocity_range = { 1, 38 },    samples = "Samples/Taiko Drum Hit 3-4.flac" },
        { velocity_range = { 39, 60 },   samples = "Samples/Taiko Drum Hit 3-3.flac" },
        { velocity_range = { 61, 82 },   samples = "Samples/Taiko Drum Hit 3-2.flac" },
        { velocity_range = { 83, 103 },  samples = "Samples/Taiko Drum Hit 3-1.flac" },
        { velocity_range = { 104, 127 }, samples = "Samples/Taiko Drum Hit 3-0.flac" },
    },
})

-- C3-C#3: Taiko Drum 4
add_drum(taiko, {
    name = "Taiko Drum 4",
    key_range = { 48, 50 },
    root_key = 48,
    layers = {
        { velocity_range = { 1, 38 },    samples = "Samples/Taiko Drum 4-4.flac" },
        { velocity_range = { 39, 60 },   samples = "Samples/Taiko Drum 4-3.flac" },
        { velocity_range = { 61, 82 },   samples = "Samples/Taiko Drum 4-2.flac" },
        { velocity_range = { 83, 103 },  samples = "Samples/Taiko Drum 4-1.flac" },
        { velocity_range = { 104, 127 }, samples = "Samples/Taiko Drum 4-0.flac" },
    },
})

-- D3-D#3: Taiko Drum 5
-- Note: SFZ has fil_type=lpf_1p, cutoff=4500, fil_veltrack=100 for first region (not supported)
add_drum(taiko, {
    name = "Taiko Drum 5",
    key_range = { 50, 52 },
    root_key = 50,
    layers = {
        { velocity_range = { 1, 38 },    samples = "Samples/Taiko Drum 5-3.flac" },
        { velocity_range = { 39, 60 },   samples = "Samples/Taiko Drum 5-3.flac" },
        { velocity_range = { 61, 82 },   samples = "Samples/Taiko Drum 5-2.flac" },
        { velocity_range = { 83, 103 },  samples = "Samples/Taiko Drum 5-1.flac" },
        { velocity_range = { 104, 127 }, samples = "Samples/Taiko Drum 5-0.flac" },
    },
})

-- F3-F#3: Taiko Drum 6
add_drum(taiko, {
    name = "Taiko Drum 6",
    key_range = { 53, 55 },
    root_key = 53,
    layers = {
        { velocity_range = { 1, 38 },    samples = "Samples/Taiko Drum 6-3.flac" },
        { velocity_range = { 39, 60 },   samples = "Samples/Taiko Drum 6-4.flac" },
        { velocity_range = { 61, 82 },   samples = "Samples/Taiko Drum 6-0.flac" },
        { velocity_range = { 83, 103 },  samples = "Samples/Taiko Drum 6-1.flac" },
        { velocity_range = { 104, 127 }, samples = "Samples/Taiko Drum 6-2.flac" },
    },
})

-- G3-G#3: Taiko Hit
add_drum(taiko, {
    name = "Taiko Hit",
    key_range = { 55, 57 },
    root_key = 55,
    layers = {
        { velocity_range = { 1, 49 },   samples = "Samples/Taiko Hit-0.flac" },
        { velocity_range = { 50, 92 },  samples = "Samples/Taiko Hit-1.flac" },
        { velocity_range = { 93, 127 }, samples = "Samples/Taiko Hit-2.flac" },
    },
})

-- A3-A#3: Taiko Crash (Freeze)
add_drum(taiko, {
    name = "Taiko Crash",
    key_range = { 57, 59 },
    root_key = 57,
    layers = {
        { velocity_range = { 1, 29 },    samples = "Samples/Taiko Crash (Freeze)-4.flac" },
        { velocity_range = { 30, 53 },   samples = "Samples/Taiko Crash (Freeze)-1.flac" },
        { velocity_range = { 54, 77 },   samples = "Samples/Taiko Crash (Freeze)-0.flac" },
        { velocity_range = { 78, 101 },  samples = "Samples/Taiko Crash (Freeze)-3.flac" },
        { velocity_range = { 102, 127 }, samples = "Samples/Taiko Crash (Freeze)-2.flac" },
    },
})

-- C4-C#4: Taiko Drum 7
-- Note: SFZ has loop_mode=no_loop and fil_type=lpf_1p, cutoff=100, fil_veltrack=9600 (not supported)
add_drum(taiko, {
    name = "Taiko Drum 7",
    key_range = { 60, 62 },
    root_key = 60,
    layers = {
        {
            samples = "Samples/Taiko C5.flac",
            loop_requirement = "never-loop",
        },
    },
})

-- D4-D#4: Taiko Drum 8 (round-robin)
add_drum(taiko, {
    name = "Taiko Drum 8",
    key_range = { 62, 64 },
    root_key = 62,
    layers = {
        {
            velocity_range = { 1, 79 },
            samples = {
                "Samples/taiko1-p.flac",
                "Samples/taiko1-m.flac",
            },
            gain_db = -3,
        },
        {
            velocity_range = { 80, 127 },
            samples = {
                "Samples/taiko1-f1.flac",
                "Samples/taiko1-f2.flac",
            },
        },
    },
})

-- F4-F#4: Taiko Drum 7+8 hybrid (round-robin)
-- This combines Taiko Drum 7 and Taiko Drum 8 on the same key range
add_drum(taiko, {
    name = "Taiko Drum 7+8",
    key_range = { 65, 67 },
    root_key = 65,
    layers = {
        {
            samples = "Samples/Taiko C5.flac",
            loop_requirement = "never-loop",
        },
        {
            velocity_range = { 1, 79 },
            samples = {
                "Samples/taiko1-p.flac",
                "Samples/taiko1-m.flac",
            },
            gain_db = -3,
        },
        {
            velocity_range = { 80, 127 },
            samples = {
                "Samples/taiko1-f1.flac",
                "Samples/taiko1-f2.flac",
            },
        },
    },
})

-- G4-G#4: Taiko Drum Sticks (round-robin)
add_drum(taiko, {
    name = "Taiko Drum Sticks",
    key_range = { 67, 69 },
    root_key = 67,
    layers = {
        {
            velocity_range = { 1, 49 },
            samples = {
                "Samples/Taiko Drum Sticks-1.flac",
                "Samples/Taiko Drum Sticks-0.flac",
            },
        },
        {
            velocity_range = { 50, 92 },
            samples = {
                "Samples/Taiko Drum Sticks-2.flac",
                "Samples/Taiko Drum Sticks-3.flac",
                "Samples/Taiko Drum Sticks-5.flac",
            },
        },
        {
            velocity_range = { 93, 127 },
            samples = {
                "Samples/Taiko Drum Sticks-4.flac",
                "Samples/Taiko Drum Sticks-6.flac",
            },
        },
    },
})

-- A4-A#4: Taiko Lt Sticks
add_drum(taiko, {
    name = "Taiko Lt Sticks",
    key_range = { 69, 71 },
    root_key = 69,
    layers = {
        { velocity_range = { 1, 27 },    samples = "Samples/Taiko Lt Sticks-0.flac" },
        { velocity_range = { 28, 54 },   samples = "Samples/Taiko Lt Sticks-1.flac" },
        { velocity_range = { 55, 81 },   samples = "Samples/Taiko Lt Sticks-2.flac" },
        { velocity_range = { 82, 104 },  samples = "Samples/Taiko Lt Sticks-3.flac" },
        { velocity_range = { 105, 127 }, samples = "Samples/Taiko Lt Sticks-4.flac", gain_db = -6 },
    },
})

return library
