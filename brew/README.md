
# Brewfile

Install commands written in Brewfile via homebrew-bundle

```
cd
brew bundle
```

If you want to update Brewfile, type:

```
brew bundle dump --force --global
```

or this one if brew-aliases is activated
(To install Homebrew Aliases, type `brew tap homebrew/aliases`).

```
brew file
```



------

Creates a dependency graph with **brew-graph**.

```
brew install martido/brew-graph/brew-graph
brew install graphviz

brew graph --installed | dot -Tpng -ograph.png
open graph.png
```



---

```makefile
# # --- make brew ---
# brew:
# 	ln $(OPTION) -s "$(PWD)/brew/.Brewfile" "$(HOME)/.Brewfile"
# 	test -d "$(HOME)/.brew-aliases" || \
# 	ln $(OPTION) -s "$(PWD)/brew/.brew-aliases" "$(HOME)/.brew-aliases"
# brew-f:
# 	$(MAKE) brew OPTION='-f'
```
