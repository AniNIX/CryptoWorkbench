# Maintainer: Shikoba Kage <darkfeather@aninix.net>
pkgname=cryptoworkbench
pkgver=0.1
pkgrel=1
epoch=
pkgdesc="Simple cryptography utilities."
arch=("x86_64")
url="https://aninix.net/foundation/CryptoWorkbench"
license=('custom')
groups=()
depends=('mono>=5.0.0' 'curl' 'grep' 'bash>=4.4' 'git>=2.13')
makedepends=('make>=4.2')
checkdepends=()
optdepends=()
provides=('cryptoworkbench')
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=()
noextract=()
md5sums=()
validpgpkeys=()

prepare() {
    git pull
}

build() {
    make -C ..
}

check() {
	printf 'quit\n\n' | make -C .. test
}

package() {
    export pkgdir="${pkgdir}"
	make -C .. install
    install -D -m644 ../LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
