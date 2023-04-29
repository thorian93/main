# Ansible Role: SSH

This role configures SSHD on RHEL/CentOS, Debian/Ubuntu, Fedora and openSUSE servers.

[![Ansible Role: SSH](https://img.shields.io/ansible/role/55144?style=flat-square)](https://galaxy.ansible.com/thorian93/ssh)
[![Ansible Role: SSH](https://img.shields.io/ansible/quality/55144?style=flat-square)](https://galaxy.ansible.com/thorian93/ssh)
[![Ansible Role: SSH](https://img.shields.io/ansible/role/d/55144?style=flat-square)](https://galaxy.ansible.com/thorian93/ssh)

## Requirements

No special requirements; note that this role requires root access, so either run it in a playbook with a global `become: yes`, or invoke the role in your playbook like:

    - hosts: foobar
      roles:
        - role: thorian93.ssh
          become: yes

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    sshd_port: '22'

Configure the port sshd listens on.

    sshd_protocol: '2'

Configure the sshd protocol to use. It is **highly** recommended to keep this at version **2**!

    sshd_address_family: 'inet'

Configure the IP address family sshd uses. Can be either `any`, `inet` or `inet6`.

    sshd_permit_root_login: 'no'

Allow login as root user.

    sshd_permit_password_authentication: "no"

Allow password authentication.

    sshd_permit_empty_passwords: 'no'

Allow empty passwords for ssh login.

    sshd_challenge_response_auth: 'no'

Enable challenge response authentication.

    sshd_gss_api_authentication: 'no'

Enable GSS API authentication.

    sshd_strict_mode: 'yes'

Use sshd strict mode.

    sshd_allowed_users: []
    sshd_allowed_groups: []

Space separated list of users and groups that may login through SSH. **Be advised that both conditions must be true!**  
For example, if you set `sshd_allowed_users` to `foo`, `foo` can login. If you additionally set `sshd_allowed_groups` to `bar` while `foo` is not a member of `bar`, `foo` will no longer be able to login.

    sshd_allow_x11_forwarding: "no"

Allow X11 forwarding.

    sshd_ciphers: []

Explicitly set all ciphers sshd should use.

    sshd_enabled_ciphers: []

Add the listed ciphers to the default ciphers sshd uses.

    sshd_disabled_ciphers: []

Remove the listed ciphers from the default ciphers sshd uses.

    sshd_usedns: 'no'

Disable reverse DNS lookups.

    sshd_print_motd: 'no'

Disable printing of motd (does not affect the banner setting below).

    sshd_banner_file: '/etc/banner'
    sshd_banner_text: ''

Configure a banner which is displayed prior to login. The file set here will be filled with the text from the respective variable. The content can be multiline, but keep the `yaml` syntax in mind (For example use `|` for multiline output).

    sshd_vault_trusted_ca_enable: 'no'

Enable to obtain and configure Vault trusted CA certificates.  
**This requires a functional [HashiCorp Vault](https://www.vaultproject.io/) instance!**

    sshd_vault_server: 'https://127.0.0.1:8200'

Domain or IP of Vault instance.

    sshd_vault_ca_cert: "trusted-user-ca-keys.pem"

Name of the CA certificate. (freely selectable)


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
        - ansible-role-ssh

## Contributing

Please feel free to open issues if you find any bugs, problems or if you see room for improvement. Also feel free to contact me anytime if you want to ask or discuss something.

## Disclaimer

This role is provided AS IS and I can and will not guarantee that the role works as intended, nor can I be accountable for any damage or misconfiguration done by this role. Study the role thoroughly before using it.

## License

MIT

## Author Information

This role was created in 2019 by [Thorian93](http://thorian93.de/).
