declare-user-mode Obsidian-kak

face global bracket_highlight pruple

# echo "autowrap-enable"

add-highlighter global/ regex \[\[.*?\]\] 0:magenta,black

define-command change-link-color -params 1 -docstring %{
	change-link-color [<color>]: Change the color of the links denoted by double brackets

	colors available: magenta, black, red, blue, white, cyan, yellow
} %{
    evaluate-commands %sh{
		echo "add-highlighter global/ regex \[\[.*?\]\] 0:$1,black"
	}
}

define-command is-obsidian-vault -docstring %{
	is-obsidian-vault: informs the user weither the directory they are in is an Obsidian Vault
} %{
	evaluate-commands %sh{
		#echo "$PWD
		filepth = "$PWD/.obsidian/workspace.json"
		if [! -f "$filepth"]; then
			echo ' echo -markup This is not an Obsidian Vault'
		else
			echo 'echo -markup This is an Obsidian Vault'
		fi
	}
}

define-command current-dir -docstring %{
	current-dir: shows the current directory
} %{
	evaluate-commands %sh{
		echo "echo -markup $(pwd)"
    }
}

define-command create-note -params 1 -docstring %{
	open-note [<name>]: creates a note (MarkDown file) in the vault

	make sure the filename does not contain .md at the end
} %{
	evaluate-commands %sh{
		# touch "$1.md"
		#~/.config/kak/plugins/Obsidian-kak/main "3" $PWD "$1"
		echo "edit '$1.md'"
    }
}


define-command paste-img -params 0..1 -docstring %{
	paste-img [<filename>]: pastes image saved in the clipboard to the end of the given file

	Dependant on wl-clipboard (working on xclip support)
} %{
	evaluate-commands %sh{
		if [ ! -d "assets" ]; then
			mkdir -p "assets"
		fi
		if [ "$1" ]; then
			filepth="$1"
		else
			filepth="$kak_bufname"
		fi
		wl-paste > $PWD/assets/$(shuf -i 0-100000000 -n 1).png
		mostRecentFile = $(ls -t | head -n 1)
		echo "echo -markup $(ls -t assets | head -n 1)"
		echo "![[$(ls -t assets | head -n 1)]]">>"$PWD/$filepth"
    }
}

complete-command -menu paste-img buffer

define-command open-vault -docstring %{
	open-obsidian: open the Obsidian app with the current vault
} %{
	evaluate-commands %sh{
		vaultName = $(basename "$PWD")
		xdg-open 'obsidian://open?vault='$vaultName''
	}
}

define-command create-all-mds -params 1 -docstring %{
	create-all-mds [<filename>]: All of the linked notes in the given file are created if not already
} %{
	evaluate-commands %sh{
		~/.config/kak/plugins/Obsidian-kak/main "0" $PWD "$1"
    }
}

complete-command -menu create-all-mds buffer

define-command open-obsidian -params 0..1 -docstring %{
	note-in-app [<filename>]: opens the given file in the Obsidian app
} %{
    
	evaluate-commands %sh{
    	if [ "$1" ]; then
			~/.config/kak/plugins/Obsidian-kak/main "1" $PWD "$1"
		else
            ~/.config/kak/plugins/Obsidian-kak/main "1" "$PWD" "$kak_bufname"
		fi
	}
}

complete-command -menu open-obsidian buffer

define-command move-note -params 1..2 -docstring %{
	move-note [<filename>] [<dirname>]: Moves the given file to the given directory
} %{
	evaluate-commands %sh{
    	if [ "$2" ]; then
    		tomove="$1"
    		tomove2="$2"
    	else
    		tomove="$kak_bufname"
    		tomove2="$1"
    	fi
		mv "$PWD/$tomove" "$PWD/$tomove2"
		echo "echo -markup moved file: $PWD/$tomove to $PWD/$tomove2"
    }
}

complete-command -menu move-note buffer

define-command create-table -params 0..1 -docstring %{
	create-table [<filename>]: creates a table in the given file
} %{
    declare-option str name %val{bufname}
	evaluate-commands %sh{
    	if [ -n "$1" ]; then
			~/.config/kak/plugins/Obsidian-kak/main "2" $PWD "$1"
		else
			filename = ""
			~/.config/kak/plugins/Obsidian-kak/main "2" $PWD "$kak_bufname"
		fi
    }
}

complete-command -menu create-table buffer

map global user n :is-obsidian-vault<ret>
map global user n :current-dir<ret>
map global user n :create-note<ret>
map global user n :change-link-color<ret>
map global user n :paste-img<ret>
map global user n :open-vault<ret>
map global user n :quick-switch<ret>
map global user n :open-obsidian<ret>
map global user m :create-table<ret>
