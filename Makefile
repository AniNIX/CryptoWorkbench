execDir=/usr/local/bin
optDir=/opt/aninix/CryptoWorkbench

compile: /usr/bin/mcs CryptoWorkbench.csharp /opt/aninix/Uniglot/
	/usr/bin/mcs -out:shell.exe /opt/aninix/Uniglot/CSharp/*.csharp *.csharp 2>&1
	
test: /usr/bin/mono compile
	# TODO This needs to be a pytest battery across the input.
	echo quit | /usr/bin/mono shell.exe ./sample.txt

clean:
	for i in `cat .gitignore`; do rm -Rf $$i; done

install: compile /bin/bash cryptoworkbench captivecrypto
	mkdir -p ${pkgdir}${optDir} 
	mkdir -p ${pkgdir}${execDir}
	install -m 555 -o 0 -g 0 shell.exe ${pkgdir}${optDir}
	install -m 555 -o 0 -g 0 regex-lookup.bash ${pkgdir}${optDir}
	install -m 755 -o 0 -g 0 cryptoworkbench ${pkgdir}${execDir}
	install -m 755 -o 0 -g 0 captivecrypto ${pkgdir}${execDir}

checkperm: 
	chmod 0555 ${pkgdir}${optDir}shell.exe 
	chmod 0755 ${pkgdir}${execDir}cryptoworkbench ${pkgdir}${execDir}captivecrypto
	chown root:root ${pkgdir}${execDir}cryptoworkbench ${pkgdir}${execDir}captivecrypto ${pkgdir}${optDir}shell.exe

sshuser: install ForceCommand.txt pwgen /usr/sbin/ssh /usr/sbin/sshd
	grep captivecrypto /etc/shells || echo '${execDir}captivecrypto' /etc/shells
	if ! id crypto &>/dev/null; then useradd -k -d /home/crypto -s ${execDir}captivecrypto crypto;  fi
	echo "crypto:$(pwgen 24 1)" | chpasswd;
	cat ./ForceCommand.txt >> /etc/ssh/sshd_config
	echo crypto | passwd --stdin crypto
	
tmux: /usr/bin/tmux
	@echo Making sure cryptoworkbench setting isn\'t already in /etc/tmux.conf...
	[ `grep -c "cryptoworkbench" /etc/tmux.conf` -eq 0 ]
	echo "bind-key -T prefix x new-window cryptoworkbench" >> /etc/tmux.conf
	echo 'bind-key -T prefix X confirm-before -p "kill-pane #P? (y/n)" kill-pane' >> /etc/tmux.conf

diff: ${execDir}captivecrypto ${execDir}cryptoworkbench
	diff ./captivecrypto ${execDir}captivecrypto 
	diff ./cryptoworkbench ${execDir}cryptoworkbench

reverse: ${execDir}captivecrypto ${execDir}cryptoworkbench
	cat ${execDir}captivecrypto > ./captivecrypto
	cat ${execDir}cryptoworkbench > ./cryptoworkbench
