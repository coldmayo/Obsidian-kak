# Obsidian-kak

This is a Kakoune plugin for using Obsidian vaults. I want this to be used in a similar way to [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim).

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
- ```:paste-img [FILE]```: puts most recently saved image into the markdown file defined in the arguement (make sure all images are saved in a directory named "assets")
	- Example use: ```:paste-img 'CookieRecipe.md'```
- ```:create-all-mds [FILE]```: this command finds out if all of the links in the given note is a file in the vault, if it is not the file will be created
	- Example use: ```:create-all-mds 'CookieRecipe.md'```
- ```:open-obsidian```: opens the currently opened vault in Obsidian
- ```:note-in-app [FILE]```: opens the given file in the currently opened vault
	- Example use: ```:note-in-app "CookieRecipe.md"```
- ```:move-note [FILE] [DIRECTORY]```: Moves the file (given by argument 1) to a directory (given by argument 2)
	- Example use: ```:move-note 'CookieRecipe.md' 'All Recipes/'```

There is more to come, I am not close to being done developing this.
