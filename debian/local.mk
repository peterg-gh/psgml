############################ -*- Mode: Makefile -*- ###########################
## local.mk --- 
## Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
## Created On       : Sat Nov 15 10:42:10 2003
## Created On Node  : glaurung.green-gryphon.com
## Last Modified By : Neil Roeth
## Last Modified On : Thursday May 21, 2009
## Status           : Unknown, Use with caution!
## HISTORY          : 
## Description      : 
## 
###############################################################################

CONFIG-indep:: stamp-conf
BUILD/psgml:: build/psgml
INST/psgml:: install/psgml
BIN/psgml:: binary/psgml

testdir:
	$(checkdir)

stamp-conf:
	$(REASON)
	-test ! -d debian/cdtd && $(MAKE) -f debian/rules explode
	./configure --verbose --prefix=$(PREFIX) --infodir=/usr/share/info \
             --sysconfdir=/etc $(confflags) 
	touch $@

STAMPS_TO_CLEAN += stamp-conf

implode:
	$(REASON)
	$(checkdir)
	-test -d debian/cdtd && (cd debian && \
           tar zfc debian.tar.gz cdtd && \
             uuencode debian.tar.gz debian.tar.gz > debian.uue \
               && rm -f debian.tar.gz )
explode:
	$(REASON)
	$(checkdir)
	-test ! -d debian/cdtd && (cd debian && uudecode debian.uue \
           && tar zfx debian.tar.gz && rm -f debian.tar.gz )

CLEAN/psgml::
	$(MAKE) clean || true
	-rm -rf $(TMPTOP)

build/psgml: stamp-build-gnus

stamp-build-gnus:
	$(checkdir)
	$(REASON)
	bash -n debian/postinst
	bash -n debian/prerm
	bash -n debian/postrm
	bash -n debian/emacsen.remove
	bash -n debian/emacsen.install
	bash -n debian/emacsen.compat
	mkdir debian/html
	(cd debian/html; \
	 makeinfo --html --split=chapter -v -o . ../../psgml.texi)
	touch stamp-build-gnus

STAMPS_TO_CLEAN += stamp-build-gnus

install/psgml: testroot
	$(REASON)
	$(checkdir)
	rm -rf $(TMPTOP)  $(TMPTOP).deb
	$(make_directory)  $(INFODIR)
	$(make_directory)  $(LISPDIR)
# 	$(make_directory)  $(STARTDIRS)
	$(make_directory)  $(DOCDIR)
	$(make_directory)  $(DOCBASE)
	$(make_directory)  $(COMPILEDIR)/install
	$(make_directory)  $(COMPILEDIR)/remove
	$(make_directory)  $(COMPILEDIR)/compat
	$(make_directory)  $(LIBDIR)
	$(install_file)    *.el                  $(LISPDIR)
	$(install_file)    Makefile.in           $(LISPDIR)
	cp -p Makefile Makefile-el
	$(install_file)    Makefile-el           $(LISPDIR)
	$(install_file)    configure             $(LISPDIR)
	chmod 0755         $(LISPDIR)/configure
	$(install_file)    debian/$(STARTFILE)   $(LISPDIR)
	$(install_program) install-sh            $(LISPDIR)
	$(install_file)    debian/psgml-html.el  $(LISPDIR)/
	$(install_file)    psgml.info            $(INFODIR)/
	$(install_file)    psgml-api.info        $(INFODIR)/
	$(install_file)    iso88591.map          $(LIBDIR)
	(cd debian; tar cf - cdtd) | (cd $(LIBDIR); tar xf -)
	$(install_file)    README.psgml          $(DOCDIR)/README.psgml
	$(install_file)    psgml.ps              $(DOCDIR)/psgml.ps
	$(install_file)    ChangeLog             $(DOCDIR)/changelog
	$(install_file)    debian/changelog      $(DOCDIR)/changelog.Debian
	$(install_file)    debian/example-customization.el $(DOCDIR)/
	$(install_file)    debian/README.debian  $(DOCDIR)
	$(install_file)    debian/Example        $(DOCDIR)/
	gzip -9nfqr        $(INFODIR)/
	gzip -9nfqr        $(DOCDIR)/
# Make sure the copyright file is not compressed
	$(install_file)    debian/copyright      $(DOCDIR)/copyright
	$(install_file)    debian/html/*.html    $(DOCDIR)/
	$(install_file)    debian/docentry       $(DOCBASE)/$(package)
	sed                -e 's/=P/$(package)/g' -e 's/=V/$(DEB_VERSION)/g' \
                              debian/emacsen.install > $(COMPILEDIR)/install/$(package)
	sed                -e 's/=P/$(package)/g' -e 's/=V/$(DEB_VERSION)/g' \
                              debian/emacsen.remove  > $(COMPILEDIR)/remove/$(package)
	$(install_file)    debian/emacsen.compat $(COMPILEDIR)/compat/$(package)
	chmod 0755        $(COMPILEDIR)/install/$(package) \
                           $(COMPILEDIR)/remove/$(package)

binary/psgml: testroot
	$(REASON)
	$(checkdir)
	$(make_directory)  $(TMPTOP)/DEBIAN
	$(install_program) debian/postinst       $(TMPTOP)/DEBIAN/postinst
	$(install_program) debian/prerm          $(TMPTOP)/DEBIAN/prerm
	$(install_program) debian/postrm         $(TMPTOP)/DEBIAN/postrm
	dpkg-gencontrol     -p$(package) -isp      -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..
