# Ansible Role: Upgrade

This role performs upgrades on Debian/Ubuntu, RHEL/CentOS, Fedora, Suse and Alpine servers.

## Features

- Reboot detection and automatic reboot
- Service restart detection and automatic service restarts
- Upgrade reporting
  - via Mail
  - via Telegram

## Here be Dragons!

The reboot and service restart checks for APT are implemented via [needrestart](https://github.com/liske/needrestart). For Fedora this is implemented through the dnf plugin [needs-restarting](https://dnf-plugins-core.readthedocs.io/en/latest/needs_restarting.html).
For RHEL/CentOS it is implemented through the [needs-restarting](https://dnf-plugins-core.readthedocs.io/en/latest/needs_restarting.html) tool.

**For Alpine Linux there is no such tool.** `apk` offers no equivalent to `needrestart`, and `needrestart` is not packaged for Alpine. Reboot and service restart detection are therefore **not implemented**.

The role uses the output or return codes respectively to decide what actions to take. You can configure the behavior through the variables below.

Neither of these methods are perfect, but it works reasonably good. You might want to look through the role before using it though.

## Known issues

- **Alpine Linux**: No reboot and service restart detection. Services keep running against deleted libraries until you restart them or reboot yourself.
- Debian 11: Without setting `ansible_python_interpreter=/usr/bin/python3` explicitly, the `apt` module will try to install `python-apt` on the fly, which fails. See [this issue](https://github.com/ansible/ansible/issues/69053) for more details.
- CentOS 8: Reboot detection does not work as there is a flag missing for the dnf needs-restarting plugin. No reboot will be performed at any time.
- Fedora 32 and earlier: Service restart detection does not work as there is a flag missing for the dnf needs-restarting plugin. No service restarts will be performed at any time.
- **opensuse 15 and 42**: A missing dependency does not allow installation of a dependent tool. A workaround is in place. Also, the upgrade process seems unstable. I will list these distributions as stable regarding below-mentionedd OS compatibility check anyway as currently the role does not seem to break stuff, but please be careful! Also feel free to give me a hint, if you know how to fix this stuff.
- **opensuse 15 and 42**: The service restart detection uses a 'brute force' approach, as the output of `zypper ps -s` is a pain in the bum to parse. So for now these OS will simply reboot if any services need to be restarted.

## Requirements

When using the reporting via Telegram feature:

    collections:
    - name: community.general
      version: 3.4.0

Note that this role requires root access, so either run it in a playbook with a global `become: yes`, or invoke the role in your playbook like:

    - hosts: foobar
      roles:
        - role: thorian93.upgrade
          become: yes

Also this role only **checks if the system is available at port 22** after a reboot. If you need further checks or validation you need to take care of that yourself.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):


### Basic Variables

    upgrade_packages_on_hold: []

Set packages which you don't want to upgrade automatically on hold before upgrading.

    upgrade_unattended_reboot: true

Enable unattended reboot in case it is necessary after updates. Default is `true`, set to `false` to disable reboots.

    upgrade_force_reboot: false

Force a reboot of each server independent of the result of the reboot check. Default is `false`, set to `true` to enable forced reboots.

    upgrade_needrestart_disable_interaction: true

The `needrestart` tool is used to determine necessary reboots and service restarts. Some distributions configure it to run interactively by default, which breaks this role. Therefore, the default setting is to disable all interaction. Set this to `false` to keep interaction enabled. See the manpage for further details.

    upgrade_restart_services: true

Enable automatic service restarts. This causes the role to restart services which need restarting. Default is `true`, set to `false` to disable reboots.

    upgrade_restart_services_blacklist:
      - auditd.service
      - dbus.service
      - systemd-manager.service

Blacklist services that should not or cannot be restarted. The default list is based on and expanded per experience. Feel free to report services that need to be added here.

### Topgrade Variables

    upgrade_topgrade_install: false

Install [topgrade](https://github.com/topgrade-rs/topgrade) from its upstream release archive. Default is `false`. Note that the role only **installs** the binary, it does not run it. Upgrades are still performed by the package manager. Only `x86_64` and `aarch64` are supported, the role fails on other architectures. On Alpine the musl build is used and `tar` and `ca-certificates` are installed, as the `unarchive` module cannot work with busybox `tar` and the download needs a CA bundle.

The downloaded archive is verified against a SHA256 checksum before it is unpacked. Upstream publishes no checksum file, so the checksums are pinned in the role's `vars/main.yml` per version and build target.

    upgrade_topgrade_version: "17.9.0"

The topgrade version to install. The role compares this against the output of `topgrade --version` and only downloads if they differ, so lowering this value downgrades the binary. **When you change this, you also have to add the matching checksums to `upgrade_topgrade_checksums` in the role's `vars/main.yml`**, otherwise the role fails rather than installing an unverified binary. The file documents how to generate them.

    upgrade_topgrade_path: "/usr/local/bin"

Where to place the topgrade binary.

    upgrade_topgrade_run: false

Run topgrade after the package manager upgrade. Default is `false`. The role fails if topgrade is not present at `upgrade_topgrade_path`, so either enable `upgrade_topgrade_install` or install it yourself.

**Be aware that this upgrades your system packages a second time**, as topgrade drives the very same package manager this role already used. Its value lies in the steps the package manager does not cover, such as `cargo`, `npm`, `pipx` or `flatpak`. Also note that topgrade runs as the user the role runs as, which is usually `root`, so it only sees `root`'s toolchains, and that the reboot and service restart detection of this role happens *before* topgrade runs, so anything topgrade installs is not covered by it.

    upgrade_topgrade_args:
      - "--yes"
      - "--allow-root"
      - "--no-ask-retry"
      - "--no-self-update"

The arguments topgrade is called with. The defaults are what makes an unattended run work at all:

- `--yes` assumes yes on every package manager prompt.
- `--allow-root` suppresses the confirmation prompt topgrade shows when running as `root`. Without it the run hangs.
- `--no-ask-retry` stops topgrade from asking what to do after a failed step. Without it the run hangs.
- `--no-self-update` keeps the version this role installed and verified. Without it topgrade may replace itself with a binary this role never checksummed.

If a step fails, topgrade exits non-zero and the task fails. Add `--disable <step>` here to skip steps you do not want.

### Reporting Variables

    upgrade_reporting_enable: false

Enable the reporting function of this role to output the installed updates and optionally write them to file.

    upgrade_reporting_path: "."

Define where the reports should be placed. Default is your current working directory.

    upgrade_reporting_cleanup: true

Clean up the report files used to send reports. Might be useful for debugging to keep them.

### Telegram Reporting Variables

    upgrade_reporting_telegram_enable: false

Enable reporting via Telegram. **You need to configure the following two variables with your credentials to actually send messages via Telegram!** See [the module documentation](https://docs.ansible.com/ansible/latest/collections/community/general/telegram_module.html) for details.

    upgrade_telegram_token:  []

Your Telegram Bot Token.

    upgrade_telegram_chatid: []

Your Telegram Chat ID.

### Mail Reporting Variables

    upgrade_reporting_mail_enable: false

Enable reporting via eMail.

    upgrade_reporting_mail_subject: "Ansible Update Role Reporting"

Configure the subject of the mail.

    upgrade_reporting_mail_to: ""

Define the recipient(s) of the mail.

    upgrade_reporting_mail_from: ""

Define the sender of the mail.

    upgrade_reporting_mail_host: ""

Define the mail server or relay.

    upgrade_reporting_mail_port: ""

Define the mail server port.

    upgrade_reporting_mail_user:
    upgrade_reporting_mail_password:

If the mail server needs authentication, set a username and password here. **If no authentication is required, make sure to leave the variables blank as seen here! Do not make it empty as seen above.**


    upgrade_reporting_mail_run_once: true

If you want to send one email per play set this to true. If you rather send one mail per host set it to `false`.

## Dependencies

None.

## OS Compatibility

This role ensures that it is not used against unsupported or untested operating systems by checking, if the right distribution name and major version number are present in a dedicated variable named like `<role-name>_stable_os`. You can find the variable in the role's default variable file at `defaults/main.yml`:

    role_stable_os:
      - Debian 10
      - Ubuntu 18
      - CentOS 7
      - Fedora 30

If the combination of distribution and major version number do not match the target system, the role will fail. To allow the role to work add the distribution name and major version name to that variable and you are good to go. But please test the new combination first!

Kudos to [HarryHarcourt](https://github.com/HarryHarcourt) for this idea!

## Example Playbook

    ---
    - name: "Run role."
      hosts: all
      become: yes
      roles:
        - ansible-role-upgrade

## Contributing

Please feel free to open issues if you find any bugs, problems or if you see room for improvement. Also feel free to contact me anytime if you want to ask or discuss something.

## Disclaimer

This role is provided AS IS and I can and will not guarantee that the role works as intended, nor can I be accountable for any damage or misconfiguration done by this role. Study the role thoroughly before using it.

## License

MIT

## Author Information

This role was created in 2019 by [Thorian93](http://thorian93.de/).
