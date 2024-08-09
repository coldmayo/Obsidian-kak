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

define-command open-note -params 1 -docstring %{
	open-note [<name>]: creates a note (MarkDown file) in the vault

	make sure the filename does not contain .md at the end
} %{
	evaluate-commands %sh{
		# touch "$1.md"
		#~/.config/kak/plugins/Obsidian-kak/main "3" $PWD "$1"
		echo "edit '$1.md'"
    }
}

define-command paste-img -params 1 -docstring %{
	paste-img [<filename>]: pastes image saved in the clipboard to the end of the given file

	Dependant on wl-clipboard (working on xclip support)
} %{
	evaluate-commands %sh{
		filepth = "$1"
		if [ ! -d "assets" ]; then
			mkdir -p "assets"
		fi
		wl-paste > $PWD/assets/$(shuf -i 0-100000000 -n 1).png
		mostRecentFile = $(ls -t | head -n 1)
		echo "echo -markup $(ls -t assets | head -n 1)"
		echo "![[$(ls -t assets | head -n 1)]]">>"$PWD/$1"
    }
}

complete-command -menu paste-img buffer

define-command open-obsidian -docstring %{
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

define-command note-in-app -params 1 -docstring %{
	note-in-app [<filename>]: opens the given file in the Obsidian app
} %{
	evaluate-commands %sh{
		~/.config/kak/plugins/Obsidian-kak/main "1" $PWD "$1"
    }
}

complete-command -menu note-in-app buffer

define-command move-note -params 2 -docstring %{
	move-note [<filename>] [<dirname>]: Moves the given file to the given directory
} %{
	evaluate-commands %sh{
		mv "$PWD/$1" "$PWD/$2"
		echo "echo -markup moved file: $PWD/$1 to $PWD/$2"
    }
}

complete-command -menu move-note buffer

define-command create-table -params 1 -docstring %{
	create-table [<filename>]: creates a table in the given file
} %{
	evaluate-commands %sh{
		~/.config/kak/plugins/Obsidian-kak/main "2" $PWD "$1"
    }
}

complete-command -menu create-table buffer

map global user n :is-obsidian-vault<ret>
map global user n :current-dir<ret>
map global user n :open-note<ret>
map global user n :change-link-color<ret>
map global user n :paste-img<ret>
map global user n :open-obsidian<ret>
map global user n :quick-switch<ret>
map global user n :note-in-app<ret>
map global user m :create-table<ret>
