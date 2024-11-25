# Obsidian-kak

This is a Kakoune plugin for using Obsidian vaults. I want this to be used in a similar way to [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim). This is a plugin I use personally for my own notetaking. I hope this will be useful to others as well. If you have any suggestions, don't be scared to submit an issue.

## Installation

To add this plugin all you have to do is
1. Ensure you have the GCC installed
2. Clone this repo into your plugins directory
3. and then add the following to your kakrc:
```bash
source ~/.config/kak/plugins/Obsidian-kak/Obsidian-kak.kak do sh%{
	cd ~/.config/kak/plugins/Obsidian-kak
	gcc -o main main.c	
}
```

## Commands

- ```:is-obsidian-vault ```: checks if current directory is an Obsidian vault
- ```:open-note [TITLE]```: used to create a new note. It has one arguement required, which is the name of the new markdown file (without the .md file extention)
	- Example use: ```:open-note CookieRecipe```
- ```:paste-img [FILE]```: puts most recently copied image into the markdown file defined in the arguement. The copied image will be saved to a folder named "assets". This is dependant on wl-clipboard.
	- Example use: ```:paste-img 'CookieRecipe.md'```
- ```:create-all-mds [FILE]```: this command finds out if all of the links in the given note is a file in the vault, if it is not the file will be created
	- Example use: ```:create-all-mds 'CookieRecipe.md'```
- ```:open-obsidian [FILE]```: opens the currently opened vault in Obsidian
	- Example use: ```:open-obsidian Plingus.md```
- ```:move-note [FILE] [DIRECTORY]```: Moves the file (given by argument 1) to a directory (given by argument 2)
	- Example use: ```:move-note 'CookieRecipe.md' 'All Recipes/'```
- ```:create-table [FILE]```: Creates a table in the given file (argument 1)
	- Example use: ```:create-table 'CookieRecipie.md'```

Note: If ```[FILE]``` is not given, it will use the file you are currently on

There is more to come, I am not close to being done developing this.
