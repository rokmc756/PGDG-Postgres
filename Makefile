USERNAME=jomoon
COMMON="yes"
ANSIBLE_HOST_PASS="changeme"
ANSIBLE_TARGET_PASS="changeme"

# Define Boot CMD
VMWARE_BOOT_CMD="power-on"
VMWARE_SHUTDOWN_CMD="shutdown-guest"
VMWARE_ROLE_CONFIG="control-vms-vmware.yml"
KVM_BOOT_CMD="start"
KVM_SHUTDOWN_CMD="shutdown"
KVM_ROLE_CONFIG="control-vms-kvm.yml"
KVM_HOST_CONFIG="ansible-hosts-fedora"
VMWARE_HOST_CONFIG="ansible-hosts-vmware"

BOOT_CMD=${KVM_BOOT_CMD}
SHUTDOWN_CMD=${KVM_SHUTDOWN_CMD}
ROLE_CONFIG=${KVM_ROLE_CONFIG}
ANSIBLE_HOST_CONFIG=${KVM_HOST_CONFIG}

# Control VMs in KVM For Power On or Off
boot:
	ansible-playbook -i ${ANSIBLE_HOST_CONFIG} --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} ${ROLE_CONFIG} --extra-vars "power_state=${BOOT_CMD} power_title=Power-On VMs"

shutdown:
	ansible-playbook -i ${ANSIBLE_HOST_CONFIG} --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} ${ROLE_CONFIG} --extra-vars "power_state=${SHUTDOWN_CMD} power_title=Shutdown VMs"

# For All Roles
%:
	@if [ "${*}" = "patroni" ]; then\
		ln -sf ansible-hosts-co10-patroni ansible-hosts;\
	elif [ "${*}" = "pgautofailover" ]; then\
		ln -sf ansible-hosts-co10-pgautofailover ansible-hosts;\
	elif [ "${*}" = "repmgr" ]; then\
		ln -sf ansible-hosts-co10-repmgr ansible-hosts;\
	elif [ "${*}" = "bucardo" ]; then\
		ln -sf ansible-hosts-co10-bucardo ansible-hosts;\
	elif [ "${*}" = "single" ] || [ "${*}" = "pgwatch2" ] || [ "${*}" = "grafana" ]; then\
		ln -sf ansible-hosts-co10-single ansible-hosts;\
	elif [ "${*}" = "mapserver" ]; then\
		ln -sf ansible-hosts-co10-mapserver ansible-hosts;\
	elif [ "${*}" = "haproxy" ]; then\
		ln -sf ansible-hosts-co10-haproxy ansible-hosts;\
	elif [ "${*}" = "hosts" ]; then\
		ln -sf ansible-hosts-co10 ansible-hosts;\
	else\
		echo "No actions to init/uninit/reinit temp";\
		exit;\
	fi
	@cat setup-temp.yml.tmp | sed -e 's/    - temp/    - ${*}/g' > setup-${*}.yml
	@cat Makefile.tmp  | sed -e 's/temp/${*}/g' > Makefile.${*}
	@make -f Makefile.${*} r=${r} s=${s} c=${c} USERNAME=${USERNAME}
	@rm -f setup-${*}.yml Makefile.${*}


# clean:
# 	rm -rf ./known_hosts install-hosts.yml update-hosts.yml


# https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
#no_targets__:
#role-update:
#	sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep '^ansible-update-*'" | xargs -n 1 make --no-print-directory
#        $(shell sed -i -e '2s/.*/ansible_become_pass: ${ANSIBLE_HOST_PASS}/g' ./group_vars/all.yml )


# Need to check what it should be needed
.PHONY:	all init install update ssh common clean no_targets__ role-update
