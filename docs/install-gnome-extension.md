# Install gome extension

## Download extension

Download `zip` or `git` repository and `cd` into extension directory

```bash
cd ~/dev/debian-os/gnome-extensions/my-ext
```

## Obtain the extension UUID

```bash
EXT_UUID=$(cat metadata.json | grep uuid | cut -d \" -f4)
EXT_INSTALL_DIR=~/.local/share/gnome-shell/extensions/$EXT_UUID
```

## Create installation directory

```bash
mkdir $EXT_INSTALL_DIR
```

## Copy extension files to installation directory

* `$EXT_INSTALL_DIR`

```bash
rsync ./my-ext/** -avh --no-perms --delete --exclude=".git" $EXT_INSTALL_DIR

```

## Enable gnome extension

```bash
gnome-shell-extension-tool -e $EXT_UUID
```

## Clean up

```bash
unset EXT_UUID;
unset EXT_INSTALL_DIR;
```
