# backstage2

> "Plug-in harddisk, start backup and wait until completed.""



## Machine Setup

- Install [Git](https://git-scm.com/downloads) (2.24.0, 2019-11-04)
    - Select Components
        - Uncheck _Additional icons_
        - Uncheck _Windows Explorer integration_
        - Check _Git LFS_
        - Check _Associate .git* configuration files with the default text editor_
        - Check _Associate .sh files to be run with Bash_
        - Uncheck _Use a TrueType font in all console windows_
        - Uncheck _Check daily for Git for Windows updates_
    - Choosing the default editor used by Git
        - Select _Use the Nano editor by default_
    - Adjusting your PATH environment
        - Select _Git from the command line and also from 3rd-party software_
    - Configuring the line ending conversions
        - Select _Checkout as-is, commit as-is_
    - Configuring the terminal emulator to use with Git Bash
        - Select _Use MinTTY_
- Install [VeraCrypt](https://www.veracrypt.fr/en/Downloads.html) (1.24-Hotfix1, 2019-10-27)
- Install [Macrium Reflect 7 - Free Edition](https://www.macrium.com/reflectfree) (7.2.4539, 2019-11-18)



## Installation and Removal

All described commands are being executed from a git-bash for Windows (not elevated).

### Install

```bash
# Clone _this repository_
git clone git@github.com:fbau3r/backstage.git "$ALLUSERSPROFILE/backstage2"

# Init machine configuration from a git-bash
$ALLUSERSPROFILE/backstage2/init-machine.sh
```

### Upgrade

```bash
# Pull repository
(cd "$ALLUSERSPROFILE/backstage2" && git pull)
```

### Uninstall

```bash
# Remove _this repository_ from machine
([[ -d "$ALLUSERSPROFILE/backstage2" ]] && rm -fR "$ALLUSERSPROFILE/backstage2")

# Review if you want to keep machine configuration
([[ -d "${USERPROFILE}/.backstage" ]] && explorer /select,"$(cygpath -w "${USERPROFILE}/.backstage")")
```



## Run

To run the backup, plug-in the external disk with encrypted file container (setup see below) and run `backup-machine.cmd` as Administrator (_**elevated**_ mode):

```bash
backup-machine.cmd
```



## Disk setup

### Setup external disk

1. **Format** disk with **NTFS** filesystem
1. In _Disk Properties_:
    1. Set the **disk name** to be `Backup Container NN`
        (where `NN` is replaced by a number)
    1. **Uncheck** disk indexing
    1. **Add** Group **Everyone** with permission **Full control** and remove any other groups or users (recursively)
1. **Copy** directory contents of `assets/external-disk/*` to disk
1. **Change** `LABEL` to `Backup Container NN` in `autorun.ini`
1. **Hide** `autorun.*` files

### Create encrypted file container

1. Start VeraCrypt in _**elevated**_ mode
    (at the end of formatting an NTFS disk, elevation will be needed and if the elevation prompt times out, formatting fails)
1. Click Button **Create Volume**
1. Choose **Create an encrypted file container**
1. Click Button **Next**
1. Choose **Standard VeraCrypt volume**
1. Click Button **Next**
1. **Choose _Volume Location_** on the external disk
    (e.g. `E:\my-backup-name.vc`)
1. Click Button **Next**
1. Leave _Encryption Options_ as they are
1. Click Button **Next**
1. **Choose _Volume Size_** to hold the future backup
    (rule of thumb: `current disk usage + ~25% potential growth space`)
1. Click Button **Next**
1. Leave _Password_ empty
1. **Check** _Use keyfiles_
1. Click Button **Keyfiles...**
    1. [Optional] If you don't have a keyfile yet, generate a new keyfile by clicking Button **Generate Random Keyfile...** and following the procedure in that dialog
1. Click Button **Add Files...**
1. **Browse** for _Keyfile_
    -_**IMPORTANT**_- Please backup this keyfile _separately_ somewhere else! If this key is lost, the **encrypted backup will be lost too**! See chapter [Backup Keyfile](#backup-keyfile).
1. Click Button **OK**
1. Click Button **Next**
1. **Choose** _Volume Format_ **NTFS** and collect some randomness
1. Click Button **Format**
1. _Wait for the formatting to finish, this may take quite some time..._
1. Click Button **OK** in the success message dialog
1. Click Button **Exit** to exit the wizard

### Setup encrypted file container

1. Mount the encrypted file container
1. In _Disk Properties_:
    1. Set the **disk name** to be `Backup Disk`
    1. **Uncheck** disk indexing
    1. **Add** Group **Everyone** with permission **Full control** and remove any other groups or users (recursively)
1. **Copy** directory contents of `assets/encrypted-disk/*` to disk
1. **Hide** `autorun.*` files

### Backup Keyfile

-_**IMPORTANT**_- Please backup this keyfile _separately_ somewhere else! If this key is lost, the **encrypted backup will be lost too**! See chapter [Backup Keyfile](#backup-keyfile).

The backups are inside an encrypted file container to secure the transport of the external disk and to allow for multiple backups of different persons on one external disk, with everyone reading only their own data.

To backup the keyfile, the key file is put in a 7-Zip archive which is then AES-256 encrypted and protected with a password. That protected key is placed on another machine than the backup machine.

For recovery purposes you will need the external disk and the password protected backup of the keyfile.

1. Create a sha256sum file from the keyfile:
    1. Open bash
    1. Change to directory of keyfile
        (e.g. `cd ~/.backstage`)
    1. Create file
        (e.g. `sha256sum 8d0b-fedbb02e8e70.key > 8d0b-fedbb02e8e70.key.sha256sum`)
1. Create encrypted, password protected archive
    1. Open 7-Zip
    1. Change to directory of keyfile
        (e.g. `~/.backstage`)
    1. Select key file and checksum file
        (e.g. `8d0b-fedbb02e8e70.key` and `8d0b-fedbb02e8e70.key.sha256sum`)
    1. Click Button **Add**
    1. Choose Archive name
        (e.g. `8d0b-fedbb02e8e70.7z`)
    1. Ensure _Archive format_ **7z**
    1. In **Encryption** group
        1. **Enter password** to protect your key with
        1. Choose _Encryption method_ **AES-256**
        1. Check **Encrypt file names**
    1. Click button **OK**
1. Put the encrypted, password protected archive to a location which is not the backed-up-disk and not the external disk (e.g. on your NAS or on another local machine)
