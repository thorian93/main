# Ansible Role: Sudo

[![Ansible Role: Sudo](https://img.shields.io/ansible/role/55145?style=flat-square)](https://galaxy.ansible.com/thorian93/sudo)
[![Ansible Role: Sudo](https://img.shields.io/ansible/quality/55145?style=flat-square)](https://galaxy.ansible.com/thorian93/sudo)
[![Ansible Role: Sudo](https://img.shields.io/ansible/role/d/55145?style=flat-square)](https://galaxy.ansible.com/thorian93/sudo)

This role configures sudo on Debian/Ubuntu, RHEL/CentOS, Fedora and opensuse/SLES servers.

## Here be Dragons!

This role has some defaults you might want to review before applying.

## Known issues

None.

## Requirements

No special requirements; note that this role requires root access, so either run it in a playbook with a global `become: yes`, or invoke the role in your playbook like:

    - hosts: foobar
      roles:
        - role: thorian93.sudo
          become: yes

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    sudo_sudoers_config_global: []
      # - filename: sudoers_config
      #   state: present
      #   lines:
      #     - "root	ALL=(ALL:ALL) ALL"
      #     - "john	ALL=(ALL:ALL) ALL"
    sudo_sudoers_config_os: []
    sudo_sudoers_config_system: []
    sudo_sudoers_config_stage: []
    sudo_sudoers_config_role: []

Configure custom sudoers configuration to be placed into `/etc/sudoers.d/`.

    sudo_passwordless_users_global: []
      # - john
    sudo_passwordless_users_os: []
    sudo_passwordless_users_system: []
    sudo_passwordless_users_stage: []
    sudo_passwordless_users_role: []

See the user variables above for the logic behind these variables. Users listed here will have passwordless sudo activated.

    sudo_defaults:
      - line: "# Defaults targetpw # ask for the password of the target user i.e. root"
        regex: '^Defaults\s*targetpw.*'
        state: 'present'
      - line: "# ALL ALL=(ALL) ALL # WARNING! Only use this together with 'Defaults targetpw'!"
        regex: '^ALL\s*ALL=\(ALL\)\s*ALL.*'
        state: 'present'
      - line: '%{{ common_admin_group }} ALL=({% if ansible_os_family == "Debian" %}ALL:ALL{% else %}ALL{% endif %}) ALL'
        regex: '(# |^)\%{{ common_admin_group }}\s*ALL=\({% if ansible_os_family == "Debian" %}ALL:ALL{% else %}ALL{% endif %}\)\s*ALL.*'
        state: 'present'
      - line: "#includedir /etc/sudoers.d"
        regex: '^#includedir\s*/etc/sudoers.d.*'
        state: 'present'

Configure sudo options. There is a default set of three options which ensure that sudo asks for the source user password rather than the destination user password. The fourth makes sure that configuration files in `/etc/sudoers.d/` are included.

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
        - ansible-role-sudo

## Contributing

Please feel free to open issues if you find any bugs, problems or if you see room for improvement. Also feel free to contact me anytime if you want to ask or discuss something.

## Disclaimer

This role is provided AS IS and I can and will not guarantee that the role works as intended, nor can I be accountable for any damage or misconfiguration done by this role. Study the role thoroughly before using it.

## License

MIT

## Author Information

This role was created in 2020 by [Thorian93](http://thorian93.de/).
