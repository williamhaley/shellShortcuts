# Short links to files

Using symlinks to files around the repo we can create short URLs using a vanity domain. This allows us to create our own short/pretty URLs to GitHub scripts and assets.

## Example

[https://gh.willhy.com/f/arch-install.sh](https://gh.willhy.com/f/arch-install.sh) is a URL that resolves to the file at the end of the symlink. This allows for simpler cURL commands.

```bash
# Short
curl https://gh.willhy.com/f/arch-install.sh | bash

# Long
curl https://raw.githubusercontent.com/williamhaley/configs/master/linux/arch-install.sh | bash
```

This guide may get out of date. Check [directly in GitHub](https://github.com/williamhaley/configs/tree/master/f) for greater accuracy.

