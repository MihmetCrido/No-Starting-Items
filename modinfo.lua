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
			{ description = "Any",  data = "NSI_ANY_CHARACTER", hover = "." },
			{ description = "Swap", data = "NSI_SWP_CHARACTER", hover = ".." },
			{ description = "New",  data = "NSI_NEW_CHARACTER", hover = "..." },
        },
        label = "No Starting Item(s)",
    },
	{	
		name = "nsi_options",
		label = "DEBUG_ nsi_options",
		options = {
			{ description = "Any",  data = "NSI_ANY_CHARACTER", hover = "." },
			{ description = "Swap", data = "NSI_SWP_CHARACTER", hover = ".." },
			{ description = "New",  data = "NSI_NEW_CHARACTER", hover = "..." }
		},
		default = "NSI_SWP_CHARACTER"
	},
	{
		name = "Pick",
		label = "??",
		hover = "???",
		options = {
			{
				description = "A",
				data = true,
			},
			{
				description = "B",
				data = false,
			}
		},
		default = true
	},
	{
		name = "Pick2",
		label = "??2",
		hover = "???2",
		options = {
			{
				description = "A2",
				data = true,
			},
			{
				description = "B2",
				data = false,
			}
		},
		default = true
	}
}
