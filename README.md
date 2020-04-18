# CryptoKitCLI
> Take Apple CryptoKit to the command line and perform cryptographic operations securely and efficiently.

[![Twitter](https://img.shields.io/badge/contact-%40alexruperez-blue)](http://twitter.com/alexruperez)
[![Swift](https://img.shields.io/badge/swift-5-orange)](https://swift.org)
[![License](https://img.shields.io/github/license/alexruperez/CryptoKitCLI)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager)
[![Swift Action](https://github.com/alexruperez/CryptoKitCLI/workflows/Swift/badge.svg)](https://github.com/alexruperez/CryptoKitCLI/actions)
[![Coverage](https://codecov.io/gh/alexruperez/CryptoKitCLI/branch/master/graph/badge.svg)](https://codecov.io/gh/alexruperez/CryptoKitCLI)
[![Documentation](https://alexruperez.github.io/CryptoKitCLI/badge.svg)](https://alexruperez.github.io/CryptoKitCLI)

## 🌟 Features

✅ Create or validate UUID (universally unique value).

✅ Perform cryptographically secure hashing (SHA-2  hash with 512, 384 or 256-bit digest).

✅ Create or validate HMAC (hash message authentication).

✅ Crypt and decrypt using AES-GCM cipher.

✅ Crypt and decrypt using ChaCha20-Poly1305 cipher.

✅ Symmetric key auto-hash to SHA-256 if needed.

🚧 X25519 key agreement and ed25519 signatures.

🚧 NIST P-521 signatures and key agreement.

🚧 NIST P-384 signatures and key agreement.

🚧 NIST P-256 signatures and key agreement.

## 🐒 Usage

Simply run:

```sh
$ cryptokit [subcommand]
```

* `-h, --help`: Show `CryptoKitCLI` help information.
* `--version`: Show `CryptoKitCLI` version.

## Subcommands

### UUID

```sh
$ cryptokit uuid
```

* `-c, --check <check>`: Validate UUID string or file path.
  
### SHA-2 Hashing

```sh
$ cryptokit hash
```

* `-d, --digest <digest>`: SHA-2 hash with the chosen digest. (default: sha512)

### HMAC

```sh
$ cryptokit hmac
```

* `-d, --digest <digest>`: SHA-2 hash with the chosen digest. (default: sha512)
* `-c, --check <check>`: Validate HMAC string or file path.

### AES-GCM

```sh
$ cryptokit aes
```

* `-n, --nonce <nonce>`: Nonce string or file path.
* `-a, --auth <auth>`: Additional data string or file path.
* `-d, --decrypt`: Decrypt the input and verify authenticity using combined data.
* `-t, --tag <tag>`: Decrypt the input and verify authenticity using authentication tag and nonce.
* `-s, --split `: Print authentication tag and nonce instead of combined data.

### ChaCha20-Poly1305

```sh
$ cryptokit poly
```

* `-n, --nonce <nonce>`: Nonce string or file path.
* `-a, --auth <auth>`: Additional data string or file path.
* `-d, --decrypt`: Decrypt the input and verify authenticity using combined data.
* `-t, --tag <tag>`: Decrypt the input and verify authenticity using authentication tag and nonce.
* `-s, --split `: Print authentication tag and nonce instead of combined data.

## 🛠 Compatibility

- macOS 10.15+

## ⚙️ Installation

There're more than one way to install `CryptoKitCLI`.

### Using [Homebrew](https://brew.sh):

```sh
$ brew install alexruperez/CryptoKitCLI/formula
```

### Using [Mint](https://github.com/yonaskolb/mint):

```sh
$ mint install alexruperez/CryptoKitCLI
```

### Compiling from source:

Make sure Xcode 11.4+ is installed first.

```sh
$ git clone https://github.com/alexruperez/CryptoKitCLI.git
$ cd CryptoKitCLI
$ make install
```

With that installed and in the `/usr/local/bin` folder, now it's ready to serve.

### Using [Swift Package Manager](https://github.com/apple/swift-package-manager):

**Use as CLI**

```shell
$ git clone https://github.com/alexruperez/CryptoKitCLI.git
$ cd CryptoKitCLI
$ swift run
```

**Use as dependency**

Add the following to your Package.swift file's dependencies:

```swift
.package(url: "https://github.com/alexruperez/CryptoKitCLI.git", from: "0.1.0")
```

And then import wherever needed: `import CryptoKitCLI`

*For more information, see [the Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).*

## 🍻 Etc.

- Contributions are very welcome.
- Attribution is appreciated (let's spread the word!), but not mandatory.

## 👨‍💻 Author

Alex Rupérez – [@alexruperez](https://twitter.com/alexruperez) – me@alexruperez.com

## 👮‍♂️ License

*CryptoKitCLI* is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
