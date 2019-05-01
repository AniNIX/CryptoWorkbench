compile: /usr/bin/mcs CryptoWorkbench.csharp /opt/aninix/Uniglot/
	/usr/bin/mcs -out:cryptoworkbench.exe /opt/aninix/Uniglot/CSharp/*.csharp *.csharp 2>&1
	
test: /usr/bin/mono compile
	# TODO This needs to be a pytest battery across the input.
	echo quit | /usr/bin/mono cryptoworkbench.exe ./sample.txt

clean:
	for i in `cat .gitignore`; do rm -Rf $$i; done

install: compile /bin/bash bash.cryptoworkbench
	mkdir -p ${pkgdir}/opt ${pkgdir}/usr/local/bin/ 
	mv cryptoworkbench.exe ${pkgdir}/opt
	cp bash.cryptoworkbench ${pkgdir}/usr/local/bin/cryptoworkbench
	cp captivecrypto.bash ${pkgdir}/usr/local/bin/captivecrypto
	make checkperm

checkperm: 
	chmod 0555 ${pkgdir}/opt/cryptoworkbench.exe ${pkgdir}/usr/local/bin/cryptoworkbench ${pkgdir}/usr/local/bin/captivecrypto
	chown root:root ${pkgdir}/usr/local/bin/captivecrypto ${pkgdir}/opt/cryptoworkbench.exe

sshuser: install ForceCommand.txt pwgen
	grep captivecrypto /etc/shells || echo '/usr/local/bin/captivecrypto' /etc/shells
	if ! id crypto &>/dev/null; then useradd -k -d /home/crypto -s /usr/local/bin/captivecrypto crypto;  fi
	echo "crypto:$(pwgen 24 1)" | chpasswd;
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
