p1:
	cd p1 && vagrant up --provision

p2:
	cd p2 && vagrant up --provision

p3:
	cd p3 && ./scripts/setup.sh

bonus:
	cd bonus && ./scripts/setup.sh

list:
	VBoxManage list vms
	
clean:
	cd p1 && vagrant destroy --force
	cd p2 && vagrant destroy --force
	./Assets/cleanup.sh

poweroff-all:
	for vm in $$(VBoxManage list runningvms | awk '{print $$1}' | tr -d '"'); do \
		VBoxManage controlvm $$vm poweroff --force; \
	done

delete-all:
	for vm in $$(VBoxManage list vms | awk '{print $$1}' | tr -d '"'); do \
		VBoxManage unregistervm $$vm --delete; \
	done

down: poweroff-all delete-all
	@echo "All VMs powered off and deleted."
	VBoxManage list vms


fclean: clean down
	@echo "All VMs cleaned up and deleted."

.PHONY: p1 p2 p3 bonus clean down poweroff-all delete-all list fclean
