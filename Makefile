INSTALL_DIR=~/PerlScripts

all:
	@echo "Please run 'make install'"

install:
	@echo ""
	@echo "Creating the directory $(INSTALL_DIR)"
	mkdir -p $(INSTALL_DIR)
	@echo ""
	@echo "Copying the scripts to the directory"
	find -name *.pl -exec cp -v {} $(INSTALL_DIR) \;
	@echo ""
	@echo "Makeing the scripts executable"
	find ~/PerlScripts -name *.pl -exec chmod +x {} \;
	@echo ""
	@echo "Please add '$(INSTALL_DIR)' to your path in the .bashrc file"

.PHONY: all install
