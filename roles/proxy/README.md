# Ansible Role: Proxy

This role manages proxy settings of Linux systems.

[![Ansible Role: Proxy](https://img.shields.io/ansible/role/55132?style=flat-square)](https://galaxy.ansible.com/thorian93/proxy)
[![Ansible Role: Proxy](https://img.shields.io/ansible/quality/55132?style=flat-square)](https://galaxy.ansible.com/thorian93/proxy)
[![Ansible Role: Proxy](https://img.shields.io/ansible/role/d/55132?style=flat-square)](https://galaxy.ansible.com/thorian93/proxy)

## Here be Dragons!

This role was just created and I can and will not guarantee that it works properly! Use at your own risk! But also feel free to share any findings.

## Requirements

No special requirements; note that this role requires root access, so either run it in a playbook with a global `become: yes`, or invoke the role in your playbook like:

    - hosts: foobar
      roles:
        - role: thorian93.proxy
          become: yes

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    proxy_apache2_configure: false
    proxy_apt_configure: false
    proxy_bash_configure: false
    proxy_dnf_yum_configure: false
    proxy_git_configure: false
    proxy_profile_configure: false
    proxy_wget_configure: false
    proxy_systemd_configure: false

Choose which parts of the system should be configured with a proxy.

    proxy_server: "127.0.0.1"

Configure which proxy server to use.

    proxy_port: "8080"

Configure the proxy port.

    proxy_exceptions:
      - 127.0.0.0/8
      - ::1

Configure proxy exceptions like e.g. local hosts.

    proxy_package_proxy_server: "{{ proxy_server }}"
    proxy_package_proxy_port: "{{ proxy_port }}"
    proxy_package_proxy_username: ""
    proxy_package_proxy_password: ""
    proxy_package_proxy_exceptions: []

Configure proxy for the package manager. Set to blank to remove.

## Dependencies

  - [thorian93.webserver](https://galaxy.ansible.com/thorian93/webserver)

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
        - thorian93.proxy

## Contributing

Please feel free to open issues if you find any bugs, problems or if you see room for improvement. Also feel free to contact me anytime if you want to ask or discuss something.

## Disclaimer

This role is provided AS IS and I can and will not guarantee that the role works as intended, nor can I be accountable for any damage or misconfiguration done by this role. Study the role thoroughly before using it.

## License

MIT

## Author Information

This role was created in 2020 by [Thorian93](http://thorian93.de/).
