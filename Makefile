# makefile for Sphinx documentation
# =================================

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = source
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

livehtml:
	sphinx-autobuild --open-browser -b dirhtml "$(SOURCEDIR)" "$(BUILDDIR)"

deploy:
	@$(SPHINXBUILD) -M dirhtml "$(SOURCEDIR)" "$(BUILDDIR)" -nW
	#  -n   Run in nit-picky mode. Currently, this generates warnings for all missing references.
	#  -W   Turn warnings into errors that stop the build.

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M dirhtml $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)