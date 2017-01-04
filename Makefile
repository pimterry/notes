PREFIX ?= /usr/local
BASH_COMPLETION_DIR := $(shell pkg-config --variable=completionsdir bash-completion) 
# pkg-config adds a space for some reason, we have to strip it off.
BASH_COMPLETION_DIR := $(strip $(BASH_COMPLETION_DIR))
USERDIR ?= $(HOME)

install: 
	@if [ -d $(BASH_COMPLETION_DIR) ]; then \
	 	echo $(BASH_COMPLETION_DIR);\
		cp notes.bash_completion "$(BASH_COMPLETION_DIR)/notes";\
	fi # Small test for bash completion support
	install -m755 -D notes $(PREFIX)/bin/notes
	install -m777 -D config.example $(USERDIR)/.config/notes/config.example
	install -D notes.1 $(PREFIX)/share/man/man1/notes.1
	mandb 1>/dev/null
uninstall:
	rm -f $(PREFIX)/bin/notes
	rm -f $(PREFIX)/share/man/man1/notes.1
	rm -f $(BASH_COMPLETION_DIR)/notes
	rm -f $(USERDIR)/.config/notes/config.example
