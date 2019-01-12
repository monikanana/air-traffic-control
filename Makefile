ERLC=/usr/bin/erlc
ERLCFLAGS=-o
SRCDIR=src
BEAMDIR=ebin

all: 
	@ mkdir -p ./$(SRCDIR)/$(BEAMDIR);
	@ $(ERLC) $(ERLCFLAGS) ./$(SRCDIR)/$(BEAMDIR) $(SRCDIR)/*.erl;
	@ erl -pa ./$(SRCDIR)/$(BEAMDIR) -noshell -eval "panel:main().";
clean: 
	@ rm -rf $(BEAMDIR);