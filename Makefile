SHELL=/bin/bash

VERSION := $$(grep 'version:' galaxy.yml | cut -d ' ' -f 2)

help:
	@echo "setup           - Run all setup target at once."
	@echo ""
	@echo "setup-python    - Prepare the system for development with Python."
	@echo ""
	@echo "setup-kvm       - Install and enable KVM and prepare Vagrant."
	@echo ""
	@echo "kvm             - Only copy the correct Vagrantfile for use with KVM."
	@echo ""
	@echo "vm              - Create a virtual development environment."
	@echo "vms        	   - Create a virtual environment with all boxes (exept for the development ones and ansidows)."
	@echo "vms-debian 	   - Create a virtual environment with all Debian family OSes."
	@echo "vms-redhat 	   - Create a virtual environment with all RedHat family OSes."
	@echo "vms-suse 	   - Create a virtual environment with all Suse family OSes."
	@echo ""
	@echo "clean           - Clean up several things"
	@echo "clean-vm        - Clean up virtual development environment."
	@echo ""
	@echo "version         - Update collection version"
	@echo ""
	@echo "Publishing:"
	@echo ""
	@echo "  release       - Build, upload, publish, announce and tag a release"
	@echo "  announce      - Announce the release"
	@echo "  publish       - Make files available, update git and announce"
	@echo ""

release:
	@./scripts/release.sh -s $(VERSION) -t $(RELEASE)

publish:

announce:

setup: setup-python setup-kvm

setup-python:
	@sudo apt-get -y update --quiet
	@sudo apt-get -y install -y \
		python3-pip \
		ca-certificates \
		curl \
		gnupg \
		lsb-release
	@python3 -m pip install pip --upgrade
	@python3 -m pip install -r requirements.txt

setup-kvm: kvm
	@sudo apt update -y
	@sudo apt install -y \
		virt-manager \
		qemu-kvm \
		libvirt-clients \
		libvirt-daemon-system \
		bridge-utils \
		virtinst \
		libguestfs-tools \
		libvirt-daemon\
		libvirt-dev \
		libxslt-dev \
		libxml2-dev \
		zlib1g-dev
	@sudo systemctl enable --now libvirtd
	@vagrant plugin install vagrant-libvirt

version:
	@newversion=$$(dialog --stdout --inputbox "New Version:" 0 0 "$(VERSION)") ; \
	if [ -n "$$newversion" ] ; then ./scripts/release.sh -s "$(VERSION)" -t $$newversion ; fi

clean: clean-vm

clean-vm:
	@vagrant destroy --force

vm:
	@vagrant up collection

vms:
	@vagrant up debsible ansibuntu anstream ansuse ansoracle # ansles ## currently no SLES box for libvirt!

vms-debian:
	@vagrant up debsible ansibuntu

vms-redhat:
	@vagrant up anstream ansoracle

vms-suse:
	@vagrant up ansuse # ansles ## currently no SLES box for libvirt!

vms-windows:
	@vagrant up ansidows

tests: test-sanity test-linting

test-sanity:
	@vagrant ssh -- -t 'cd /home/vagrant/ansible_collections/thorian93/main && /home/vagrant/.local/bin/ansible-test sanity --docker'

test-linting:
	@vagrant ssh -- -t 'cd /home/vagrant/ansible_collections/thorian93/main && yamllint -c .yamllint roles/'
	@vagrant ssh -- -t 'cd /home/vagrant/ansible_collections/thorian93/main && yamllint -c .yamllint playbooks/'
	@vagrant ssh -- -t 'cd /home/vagrant/ansible_collections/thorian93/main && ansible-lint -c .ansible-lint playbooks/'

tests-molecule: test-molecule-upgrade

test-molecule-upgrade:
	@vagrant ssh -- -t 'cd /home/vagrant/ansible_collections/thorian93/main/roles/upgrade && molecule test'
