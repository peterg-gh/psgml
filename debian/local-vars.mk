############################ -*- Mode: Makefile -*- ###########################
## local-vars.mk --- 
## Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
## Created On       : Sat Nov 15 10:43:00 2003
## Created On Node  : glaurung.green-gryphon.com
## Last Modified By : Manoj Srivastava
## Last Modified On : Sat Dec 13 14:43:12 2003
## Last Machine Used: glaurung.green-gryphon.com
## Update Count     : 15
## Status           : Unknown, Use with caution!
## HISTORY          : 
## Description      : 
## 
## arch-tag: 1a76a87e-7af5-424a-a30d-61660c8f243e
## 
###############################################################################

# Location of the source dir
SRCTOP    := $(shell if [ "$$PWD" != "" ]; then echo $$PWD; else pwd; fi)

TMPTOP     = $(SRCTOP)/debian/$(package)
LINTIANDIR = $(TMPTOP)/usr/share/lintian/overrides
DOCBASE    = $(TMPTOP)/usr/share/doc-base
MENUDIR    = $(TMPTOP)/usr/lib/menu/
ETCDIR     = $(TMPTOP)/usr/share/emacs/site-lisp/etc
BINDIR     = $(TMPTOP)/usr/bin
SBINDIR    = $(TMPTOP)/usr/sbin

# Man Pages
MANDIR    = $(TMPTOP)/usr/share/man
MAN1DIR   = $(MANDIR)/man1
MAN3DIR   = $(MANDIR)/man3
MAN5DIR   = $(MANDIR)/man5
MAN7DIR   = $(MANDIR)/man7
MAN8DIR   = $(MANDIR)/man8

INFODIR = $(TMPTOP)/usr/share/info
DOCTOP  = $(TMPTOP)/usr/share/doc
DOCDIR  = $(DOCTOP)/$(package)

LIBDIR  = $(TMPTOP)/usr/share/sgml/charsets

LISPDIR   = $(TMPTOP)/usr/share/emacs/site-lisp/$(package)
COMPILEDIR= $(TMPTOP)/usr/lib/emacsen-common/packages/
STARTFILE = $(package)-init.el


FILES_TO_CLEAN = debian/files debian/substvars config.cache config.log	\
                 config.status Makefile
STAMPS_TO_CLEAN = 
DIRS_TO_CLEAN   = debian/html debian/cdtd

define checkdir
	@test -f debian/rules -a -f psgml.el || \
          (echo Not in correct source directory; exit 1)
endef

define checkroot
	@test $$(id -u) = 0 || (echo need root priviledges; exit 1)
endef
