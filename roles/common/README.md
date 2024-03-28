# Ansible Role: Common

This role manages several parts of a Linux system which are not worth their own role.

[![Ansible Role: Common](https://img.shields.io/ansible/role/55131?style=flat-square)](https://galaxy.ansible.com/thorian93/common)
[![Ansible Role: Common](https://img.shields.io/ansible/quality/55131?style=flat-square)](https://galaxy.ansible.com/thorian93/common)
[![Ansible Role: Common](https://img.shields.io/ansible/role/d/55131?style=flat-square)](https://galaxy.ansible.com/thorian93/common)

## Here be Dragons!

When managing DNS resolution with this role be aware of the following: On Ubuntu this role will remove the symlink on /etc/resolv.conf if it exists and replace it with a static file. The symlink originates in the `systemd-resolved` daemon. Managing that daemon is at least currently out of scope for this role. I know this not a beautiful solution but it works for me. If you know how to handle this better feel free to contact me or create a PR.

## Known issues

- Fedora 30: The dropping support for Python 2 in Fedora causes problems for Ansible. This can be fixed by setting the `ansible_python_interpreter` variable to the appropriate Python 3 binary.
- **opensuse 15.2 and 42.2**: A missing dependency does not allow installation of a dependent tool. A workaround is in place but does not work properly.

## Requirements

No special requirements; note that this role requires root access, so either run it in a playbook with a global `become: yes`, or invoke the role in your playbook like:

    - hosts: foobar
      roles:
        - role: thorian93.common
          become: yes

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    common_configure_crontabs: false
    common_configure_disks: false
    common_configure_dns: false
    common_configure_groups: false
    common_configure_zsh: false
    common_configure_scripting: false
    common_configure_software: false
    common_configure_users: false
    common_configure_timezone: false
    common_configure_vim: false

Enable and disable managed sections of this role.

    common_host_name: "{{ inventory_hostname }}"

Configure the managed systems hostname. This defaults to the `inventory_hostname`.

    common_global_users_present: []
      # - name: johndoe
      #   password: []
      #   update_password: always
      #   keys: []
      #     - foobar
      #   shell: /bin/bash
      #   user_groups: []
      #   append: yes
      #   system: no
      #   state: present
      #   remove: no
    common_os_users_present: []
    common_system_users_present: []
    common_stage_users_present: []
    common_role_users_present: []

Users can be defined on several levels. This role defines five levels based on my personal experience. All above variables will be concatenated so every system gets the exact users intended for it. The variables are intended to be used in the above shown order. So for global users that should be present on any machine in your inventory you want to use `common_global_users_present` while the other stages can be used as seen fit. The commented block shows the currently available values to be configured for a user.

    common_optional_apps_install: false

Enable installation of optional apps.

    common_epel_enabled: false

Enable EPEL repository on RedHat derivates.

    common_dns_search: []

Configure DNS search path e.g for your local network.

    common_dns_servers:
      - 1.1.1.1
      - 1.0.0.1

Configure your DNS servers.

    common_dns_options:
      # - "timeout:3"
      # - "attempts:2"
      # - "rotate"

Configure additional options for resolv.conf

    common_timezone: "Europe/Berlin"

Configure the timezone.

    common_scripting_path: /opt/control/scripts
    common_config_path: /opt/control/config

Configure general paths.

    common_shopt_options:
      - shopt -s cdspell
      - shopt -s nocaseglob

Configure global shopt options.

    common_zsh_users: root

Configure ZSH for this users.

    common_zsh_theme: clean

Configure the oh my zsh theme.

    common_zsh_path: /opt/oh-my-zsh

Configure the oh my zsh installation path.

    common_zsh_plugins:
    - git
    - rsync
    - wd

Enable these oh my zsh plugins.

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
        - ansible-role-common

## Contributing

Please feel free to open issues if you find any bugs, problems or if you see room for improvement. Also feel free to contact me anytime if you want to ask or discuss something.

## Disclaimer

This role is provided AS IS and I can and will not guarantee that the role works as intended, nor can I be accountable for any damage or misconfiguration done by this role. Study the role thoroughly before using it.

## License

MIT

## Author Information

This role was created in 2020 by [Thorian93](http://thorian93.de/).
