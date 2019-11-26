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
