## Using this overlay
Add the URL to the **/etc/layman/layman.cfg** file:
```
https://raw.github.com/ormorph/TDE/master/layman/tde.overlay
```
It should look something like this:
```
overlays  :
    https://api.gentoo.org/overlays/repositories.xml
    https://raw.github.com/ormorph/TDE/master/layman/tde.overlay
```
Next, run the command:
```console
# layman --fetch
```
After that the command:
```console
# layman -L
```
the command must show the presence of the **TDE** overlay.

Next, set the overlay with the command:
```console
# layman -a TDE
```
Next, determine the version of TDE to install.
There are several files in the **/var/lib/layman/TDE/package.keywords** directory:
* the **tde-14.0.6** file corresponds to TDE version 14.1.6;
* the **tde-14.0.999** file corresponds to TDE version 14.0.x;
* the **tde-999** file corresponds to TDE version 14.1.x, master branch;

Select the required version and create a symbolic link to the file corresponding to the selected version:
```
# cd /etc/portage/package.keywords
# ln -sf /var/lib/layman/TDE/package.keywords/tde-14.0.6
```
Select the language to install, for this, use the **L10N** variable in the **/etc/portage/make.conf** file:
```
L10N="de,en"
```
For a minimal installation, run the command:
```
# emerge -av tde-minimal
```
For a basic installation, run the command:
```
# emerge -av tde-base
```
