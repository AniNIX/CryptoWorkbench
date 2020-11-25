# Maintainer: Shikoba Kage <darkfeather@aninix.net>
pkgname=cryptoworkbench
pkgver=0.2.4b6f343
pkgver() {
    printf "0.2.""$(git rev-parse --short HEAD)"
}
pkgrel=1
epoch=
pkgdesc="AniNIX::CryptoWorkbench \\\\ Simple Cryptography Utility"
arch=("x86_64")
url="https://aninix.net/foundation/CryptoWorkbench"
license=('custom')
groups=()
depends=('mono>=5.0.0' 'curl' 'grep' 'bash>=4.4' 'git>=2.13' 'Uniglot')
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
	printf 'quit\n\n' | make -C "${srcdir}/.." test
}

package() {
    export pkgdir="${pkgdir}"
	make -C .. install
    install -D -m644 ../LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
