dnl -------------------------------
dnl Emacs LISP file handling
dnl     Idea stolen from Ulrich Drepper's <drepper@ipd.info.uni-karlsruhe.de>
dnl     gettext-0.10 package
dnl     We do not check for EMACS
dnl -------------------------------
AC_DEFUN(ke_PATH_LISPDIR,
    [AC_MSG_CHECKING([where .elc files should go])
    dnl Set default value
    LISPDIR="\$(datadir)/emacs/site-lisp"
    if test "x$prefix" = "xNONE"; then
      if test -d $ac_default_prefix/share/emacs/site-lisp; then
	LISPDIR="\$(prefix)/share/emacs/site-lisp"
      else
	if test -d $ac_default_prefix/lib/emacs/site-lisp; then
	  LISPDIR="\$(prefix)/lib/emacs/site-lisp"
	fi
      fi
    else
      if test -d $prefix/share/emacs/site-lisp; then
	LISPDIR="\$(prefix)/share/emacs/site-lisp"
      else
	if test -d $prefix/lib/emacs/site-lisp; then
	  LISPDIR="\$(prefix)/lib/emacs/site-lisp"
	fi
      fi
    fi
    AC_MSG_RESULT($LISPDIR)
    ELCFILES="\$(ELCFILES)"
  AC_SUBST(LISPDIR)])

