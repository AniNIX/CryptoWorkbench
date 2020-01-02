CryptoWorkbench is a cryptography suite. This project is to allow easy deciphering of text-based ciphers. We will start with basic functions and add new ones as possible.

The format for this project should be as follows:
 * cryptoworkbench.csharp contains CLI commands and command reference to each cipher's API.
 * Analysis functions should be placed in the Analysis class, and simple character operations go in Simple.
 * CharGrid offers a means to make horizontal and vertical arrays of characters from strings.
 * Each cipher should implement the abstract AniNIX.Crypto.Cipher and may add unique functions. 

A sample.txt file is provided for test purposes, and a Makefile contains all your compilation rules. The bash script will allow invocation on UNIX machines.

# Usage
There's a number of ways to use this product:
* Contact an Admin on IRC for access to the hosted software.
* [Download a copy](https://aninix.net/maat) of the compiled executable to use on Windows.
* Download and compile your own. Makefile and PKGBUILD are provided.

Once in the interface, "help" will show the base help menu, and running "<command> help" will show help for individual modules.

CryptoWorkbench accepts a filepath as an argument -- this will be read in as the initial plaintext (or ciphertext).

# Focus
This project was inspired by [Rumkin's Cipher Tools](http://rumkin.com/tools/cipher/) and is designed to be used in an offline state. We also compare our implementation to the global spec of ciphers and are working to add new ones on a semiregular basis.

# Submitting New Ciphers
Post a pull request.
