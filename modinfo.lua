name = "No more starting items"
description = ""
author = "Mihmetcrido"
version = "0.01"
forumthread = ""
api_version_dst = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = false
client_only_mod = false

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true


configuration_options =
{
	{
        name = "Pick",
        label = "??",
        hover = "???",
        options = {
            {
                description = "A",
                data = true;
            },
            {
                description = "B",
                data = false;
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
                data = true;
            },
            {
                description = "B2",
                data = false;
            }
        },
        default = true
    },
	{
		name = "winter",
		label = "Starting Items",
		options =	{
						{description = "Winter : Nothing", data = "w_nothing", hover = "Nothing"},
						{description = "Winter : Basic", data = "w_basic", hover = "Hot Chili"},
						{description = "Winter : Normal", data = "w_normal", hover = "Hot Chili, Torch"},
						{description = "Winter : Lot", data = "w_lot", hover = "Hot Chili, Torch, Earmuffs"},
						{description = "Winter : Plenty", data = "w_plenty", hover = "Hot Chili, Torch, Earmuffs, Thermal Stone"}
					},
		default = "w_basic"
	},
	{
		name = "spring",
		label = "Starting Items",
		options =	{
						{description = "Spring : Nothing", data = "sp_nothing", hover = "Nothing"},
						{description = "Spring : Basic", data = "sp_basic", hover = "Pretty Parasol"},
						{description = "Spring : Normal", data = "sp_normal", hover = "Pretty Parasol, Torch"},
						{description = "Spring : Lot", data = "sp_lot", hover = "Umbrella, Torch"},
						{description = "Spring : Plenty", data = "sp_plenty", hover = "Umbrella, Torch, Rain Hat"}
					},
		default = "sp_nothing"
	},
	{
		name = "summer",
		label = "Starting Items",
		options =	{
						{description = "Summer : Nothing", data = "su_nothing", hover = "Nothing"},
						{description = "Summer : Basic", data = "su_basic", hover = "Whirly Fan"},
						{description = "Summer : Normal", data = "su_normal", hover = "Whirly Fan, Pretty Parasol"},
						{description = "Summer : Lot", data = "su_lot", hover = "Whirly Fan, Pretty Parasol, Straw Hat"},
						{description = "Summer : Plenty", data = "su_plenty", hover = "Whirly Fan, Pretty Parasol, Ice Cube"}
					},
		default = "su_basic"
	}
}


