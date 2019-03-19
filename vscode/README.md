
# VSCode

## MacOS

```
cd ~/Library/Application\ Support/Code/
rm -r ./User
ln -s ~/.dotfiles/vscode User
```

## snippets

c.json

```
{
/*
	// Place your snippets for C here. Each snippet is defined under a snippet name and has a prefix, body and
	// description. The prefix is what is used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. Placeholders with the
	// same ids are connected.
	// Example:
	"Print to console": {
		"prefix": "log",
		"body": [
			"console.log('$1');",
			"$2"
		],
		"description": "Log output to console"
	}
*/
	"#include <>": {
		"prefix": "inc",
		"body": "#include <$1>"
	},
	"#include \"\"": {
		"prefix": "Inc",
		"body": "#include \"$1\""
	},
	"int main(int argc, char **argv)": {
		"prefix": "main",
		"body": [
			"int main(int argc, char **argv) {",
			"\t$0",
			"\treturn 0;",
			"}"
		]
	}
}
```

## locale.json

```
{
	// Defines VSCode's desplay language.
	// See https://go.microsoft.com/fwlink/?LinkId=761051 for a list of supported languages.
	// Changing the value requires to restart VSCode.
	"locale":"en"
}
```
