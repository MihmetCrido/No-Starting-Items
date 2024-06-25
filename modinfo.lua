name = "No starting items"
description = ""
author = "Mihmetcrido"
version = "0.1"
forumthread = ""
api_version_dst = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = false
client_only_mod = false

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

configuration_options = {
    {
        name = "NSI_OPTIONS",
        default = "NSI_SWP_CHARACTER",
        options = {
			{ description = "Any",  data = "NSI_ANY_CHARACTER", hover = "No starting items when starting the game as any character" },
			{ description = "Swap", data = "NSI_SWP_CHARACTER", hover = "No starting items when swapping at the celestial portal" },
			{ description = "Old",  data = "NSI_OLD_CHARACTER", hover = "No starting items when picking a character you've already played" },
        },
        label = "No Starting Item(s) on ...",
    }
}
