INSTALLER != curl -s https://aninix.net/foundation/installer-test.bash | /bin/bash

tester:
	echo ${pkgbuild}/opt

compile: clean /usr/bin/mcs CryptoWorkbench.csharp
	if [ ! -d ../SharedLibraries ]; then git -C /usr/local/src clone https://aninix.net/foundation/SharedLibraries; fi
	git -C /usr/local/src/SharedLibraries pull
	/usr/bin/mcs -out:cryptoworkbench.exe ../SharedLibraries/CSharp/*.csharp *.csharp 2>&1
	
test: /usr/bin/mono compile
	echo quit | /usr/bin/mono cryptoworkbench.exe ./sample.txt

clean:
	if [ -f cryptoworkbench.exe ]; then rm cryptoworkbench.exe; fi

install: compile /bin/bash bash.cryptoworkbench
	mkdir -p ${pkgdir}/opt ${pkgdir}/usr/local/bin/ ${pkgdir}/usr/local/bin/
	mv cryptoworkbench.exe ${pkgdir}/opt
	cp bash.cryptoworkbench ${pkgdir}/usr/local/bin/cryptoworkbench
	cp captivecrypto.bash ${pkgdir}/usr/local/bin/captivecrypto
	make checkperm

checkperm: 
	chmod 0555 ${pkgdir}/opt/cryptoworkbench.exe ${pkgdir}/usr/local/bin/cryptoworkbench ${pkgdir}/usr/local/bin/captivecrypto
	chown root:root ${pkgdir}/usr/local/bin/captivecrypto ${pkgdir}/opt/cryptoworkbench.exe

sshuser: install ForceCommand.txt
	grep captivecrypto /etc/shells || echo '/usr/local/bin/captivecrypto' /etc/shells
	id crypto || useradd -k -d /home/crypto -s /usr/local/bin/captivecrypto crypto
	cat ./ForceCommand.txt >> /etc/ssh/sshd_config
	echo crypto | passwd --stdin crypto
	
tmux: /usr/bin/tmux
	@echo Making sure cryptoworkbench setting isn\'t already in /etc/tmux.conf...
	[ `grep -c "cryptoworkbench" /etc/tmux.conf` -eq 0 ]
	echo "bind-key -T prefix x new-window cryptoworkbench" >> /etc/tmux.conf
	echo 'bind-key -T prefix X confirm-before -p "kill-pane #P? (y/n)" kill-pane' >> /etc/tmux.conf

diff: captivecrypto.bash
	diff captivecrypto.bash /usr/local/bin/captivecrypto 
	diff ./bash.cryptoworkbench /usr/local/bin/cryptoworkbench

reverse:
	cat /usr/local/bin/captivecrypto > ./captivecrypto.bash 
	cat /usr/local/bin/cryptoworkbench > ./bash.cryptoworkbench
