TMUXSetting != grep -c "cryptoworkbench" /etc/tmux.conf

compile: clean /usr/bin/mcs analysis.csharp substitution.csharp caesarian.csharp cryptoworkbench.csharp
	/usr/bin/mcs -out:cryptoworkbench.exe *.csharp 2>&1 | grep -v 'is assigned but its value is never used'
	
test: /usr/bin/mono compile
	/usr/bin/mono cryptoworkbench.exe ./sample.txt

clean:
	if [ -f cryptoworkbench.exe ]; then rm cryptoworkbench.exe; fi

install: compile /bin/bash bash.cryptoworkbench
	mv cryptoworkbench.exe /opt
	chmod 0555 /opt/cryptoworkbench.exe
	cp bash.cryptoworkbench /usr/local/bin/cryptoworkbench
	chmod 0555 /usr/local/bin/cryptoworkbench
	cp captivecrypto.bash /usr/local/bin/captivecrypto
	chown root:root /usr/local/bin/captivecrypto
	chmod 0755 /usr/local/bin/captivecrypto

webapp: install
	javac CryptoApplet.java
	@echo TODO this is a work in progress.
	@echo Install the CryptoApplet.class and crypto.phpsnip into a webpage for your site.

sshuser: install ForceCommand.txt
	grep captivecrypto /etc/shells || echo '/usr/local/bin/captivecrypto' /etc/shells
	id crypto || useradd -k -d /home/crypto -s /usr/local/bin/captivecrypto crypto
	cat ./ForceCommand.txt >> /etc/ssh/sshd_config
	echo crypto | passwd --stdin crypto
	
tmux: /usr/bin/tmux
	@echo Making sure cryptoworkbench setting isn\'t already in /etc/tmux.conf...
	[ "${TMUXSetting}" -eq 0 ]
	echo "bind-key -T prefix x new-window cryptoworkbench" >> /etc/tmux.conf
	echo 'bind-key -T prefix X confirm-before -p "kill-pane #P? (y/n)" kill-pane' >> /etc/tmux.conf
