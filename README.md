# Homebrew tap for Slothmore

Formulae for [Slothmore](https://github.com/markusswedpal/slothmore), a local dashboard that starts web servers and runs scripts from your folders.

## Install

```
brew install markusswedpal/tap/slothmore
slothmore
```

That starts the dashboard at http://127.0.0.1:7777 and opens it in your browser.

To start it at login and keep it running:

```
brew services start slothmore
```

## Updating the bottle URL hash

The formula's `sha256` must match the GitHub-generated source archive for the tag (`https://github.com/markusswedpal/slothmore/archive/refs/tags/v0.1.0.tar.gz`). That hash is only known after the tag exists. From this repository's root, run:

```
python3 -c 'import hashlib,pathlib,urllib.request; u="https://github.com/markusswedpal/slothmore/archive/refs/tags/v0.1.0.tar.gz"; h=hashlib.sha256(urllib.request.urlopen(u).read()).hexdigest(); p=pathlib.Path("Formula/slothmore.rb"); p.write_text(p.read_text().replace("SHA256_PLACEHOLDER", h, 1)); print(h)'
```

That prints the hash and patches `Formula/slothmore.rb` in place. Commit and push the change so `brew install` can verify the download.

## Uninstall

```
brew services stop slothmore
brew uninstall slothmore
```

Settings and logs in `~/.slothmore` are left in place.
