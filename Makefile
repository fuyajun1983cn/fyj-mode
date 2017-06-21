# -*- Makefile -*-

EMACS = emacs

# Compile with noninteractive and relatively clean environment.
BATCHFLAGS = -batch -Q

SRCS = fyj-mode.el

OBJS = $(SRCS:.el=.elc)

%.elc: %.el
	${EMACS} $(BATCHFLAGS) -L . -f batch-byte-compile $^

all: $(OBJS)

clean:
	-rm -f $(OBJS)

test:
	${EMACS} $(BATCHFLAGS) -L . -l fyj-mode.el 
