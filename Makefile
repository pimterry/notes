PREFIX ?= /usr/local
BASH_COMPLETION_DIR := $(shell pkg-config --variable=completionsdir bash-completion) 
# pkg-config adds a space for some reason, we have to strip it off.
BASH_COMPLETION_DIR := $(strip $(BASH_COMPLETION_DIR))
USERDIR ?= $(HOME)

# The @ symbols make the output silent.
# the \033[0m stuff is ansi color escape codes.

install: 
	@if [ -d $(BASH_COMPLETION_DIR) ]; then \
		cp notes.bash_completion "$(BASH_COMPLETION_DIR)/notes"; \
	else \
		echo "Bash Completion was not installed, because the directory was" \
		"not found. if you have bash completion installed, follow the" \
		"README (https://github.com/pimterry/notes#installing-bash-completion)" \
		"to manually install it."; \
	fi # Small test for bash completion support
	@install -m755 -D notes $(PREFIX)/bin/notes
	@install -m777 -D config $(USERDIR)/.config/notes/config
	@install -D notes.1 $(PREFIX)/share/man/man1/notes.1
	@mandb 1>/dev/nulli 2>&1 # Fail silently if we don't have a mandb
	@echo -e "Notes has been installed to \033[0;32m$(PREFIX)/bin/notes." \
	"\n\033[0mA configuration file has also been created at" \
	"\033[0;32m$(USERDIR)/.config/notes/config,\033[0m" \
	"which you can edit if you'd like to change the default settings." \
	"\nGet started now by running \033[0;32mnotes open my-new-note\033[0m" \
	"Or you can run \033[0;32mnotes help\033[0m for more info"
	
uninstall:
	rm -f $(PREFIX)/bin/notes
	rm -f $(PREFIX)/share/man/man1/notes.1
	rm -f $(BASH_COMPLETION_DIR)/notes
	rm -f $(USERDIR)/.config/notes/config.example
