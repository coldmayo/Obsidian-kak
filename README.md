# Obsidian-kak

This is a Kakoune plugin for using Obsidian vaults. I want this to be used in a similar way to [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim).

## Commands

- ```:is-obsidian-vault ```: checks if current directory is an Obsidian vault
- ```:open-note [TITLE]```: used to create a new note. It has one arguement required, which is the name of the new markdown file (without the .md file extention)
	- Example use: ```:open-note CookieRecipe```
- ```:paste-img [FILE]```: puts most recently saved image into the markdown file defined in the arguement (make sure all images are saved in a directory named "assets")
	- Example use: ```:paste-img CookieRecipe.md```

There is more to come, I am not close to being done developing this.
