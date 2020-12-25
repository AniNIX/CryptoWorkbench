execDir=/usr/local/bin/
optDir=/opt/aninix/CryptoWorkbench/

compile: /usr/bin/mcs CryptoWorkbench.csharp /opt/aninix/Uniglot/
	if ! id crypto &>/dev/null; then sudo useradd -d /home/crypto -s /sbin/nologin crypto; echo "crypto:$$(pwgen 24 1)" | sudo chpasswd; fi
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

diff: ${execDir}captivecrypto ${execDir}cryptoworkbench
	diff ./captivecrypto ${execDir}captivecrypto 
	diff ./cryptoworkbench ${execDir}cryptoworkbench

reverse: ${execDir}captivecrypto ${execDir}cryptoworkbench
	cat ${execDir}captivecrypto > ./captivecrypto
	cat ${execDir}cryptoworkbench > ./cryptoworkbench
