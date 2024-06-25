declare-user-mode Obsidian-kak

face global bracket_highlight pruple

# echo "autowrap-enable"

add-highlighter global/ regex \[\[.*?\]\] 0:magenta,black

define-command -params 1 -docstring "Change color of linked files i.e. everything inside double brackets" change-link-color %{
	evaluate-commands %sh{
		echo "add-highlighter global/ regex \[\[.*?\]\] 0:$1,black"
	}
}

define-command -docstring "Is this directory an Obsidian Vault?" is-obsidian-vault %{
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

define-command -docstring "Find Current Directory" current-dir %{
	evaluate-commands %sh{
		echo "echo -markup $(pwd)"
    }
}

define-command -params 1 -docstring "Create new markdown file" open-note %{
	evaluate-commands %sh{
		touch $1.md
		name = $1
		echo "edit $1.md"
    }
}

define-command -params 1 -docstring "Paste most recenly saved image to end of the file" paste-img %{
	evaluate-commands %sh{
		filepth = "$1"
		mostRecentFile = $(ls -t | head -n 1)
		echo "echo -markup $(ls -t assets | head -n 1)"
		echo "![[$(ls -t assets | head -n 1)]]">>"$PWD/$1"
    }
}

define-command -docstring "Open this vault in the Obsidian app" open-obsidian %{
	evaluate-commands %sh{
		vaultName = $(basename "$PWD")
		xdg-open 'obsidian://open?vault='$vaultName''
    }
}

define-command -params 1 -docstring "This command makes all links not yet in the vault into markdown files" create-all-mds  %{
	evaluate-commands %sh{
		~/.config/kak/plugins/Obsidian-kak/main $PWD "$1"
		done
    }
}

map global user n :is-obsidian-vault<ret>
map global user n :current-dir<ret>
map global user n :open-note<ret>
map global user n :change-link-color<ret>
map global user n :paste-img<ret>
map global user n :open-obsidian<ret>
map global user n :quick-switch<ret>
