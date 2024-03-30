# Ansible Role: Webserver

---

## Unmaintained! Moved to collection!
This role has moved to my [**web** collection](https://github.com/thorian93/web).  
It is **not** maintained here anymore!  
Head over to the [collection](https://github.com/thorian93/web) for up to date content.

---

This role is a meta role to enable unified usage of webserver roles. It provides variables to be used in different roles.

[![Ansible Role: Webserver](https://img.shields.io/ansible/role/55151?style=flat-square)](https://galaxy.ansible.com/thorian93/webserver)
[![Ansible Role: Webserver](https://img.shields.io/ansible/quality/55151?style=flat-square)](https://galaxy.ansible.com/thorian93/webserver)
[![Ansible Role: Webserver](https://img.shields.io/ansible/role/d/55151?style=flat-square)](https://galaxy.ansible.com/thorian93/webserver)

## Here be Dragons!

No dragons here anymore.

## Requirements

No special requirements; note that this role requires root access, so either run it in a playbook with a global `become: yes`, or invoke the role in your playbook like:

    - hosts: foobar
      roles:
        - role: thorian93.webserver
          become: yes

## Role Variables

**Note that the variables in the `vars/` directory are not intended to be used directly!**

Rather refer to the variables this role discovers:

    webserver_name: []

The name of the webserver. Currently the following can be discovered: `apache2`, `httpd` and `nginx`.

    webserver_user: []

The user the webserver runs as. See the corresponding file in `vars/` for details.

    webserver_conf_file: []

The main configuration file of the webserver. See the corresponding file in `vars/` for details.

---

For full disclosure the variables from `vars/Debian.yml`, `vars/RedHat.yml` and `vars/Suse.yml` are listed here anyway:

    webserver_apache_name: apache2
    webserver_apache_user: www-data
    webserver_apache_conf_file: /etc/apache2/apache2.conf
    webserver_apache_manager: apache2ctl
    webserver_apache_site_dir: "/etc/{{ webserver_apache_name }}/sites-available"

These variables describe the Apache2 webserver.

    webserver_nginx_name: nginx
    webserver_nginx_user: nginx
    webserver_nginx_conf_file: /etc/nginx/nginx.conf
    webserver_nginx_manager: nginx
    webserver_nginx_site_dir: "/etc/{{ webserver_nginx_name }}/conf.d"

These variables describe the NGINX webserver.

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
        - ansible-role-webserver

## Contributing

Please feel free to open issues if you find any bugs, problems or if you see room for improvement. Also feel free to contact me anytime if you want to ask or discuss something.

## Disclaimer

This role is provided AS IS and I can and will not guarantee that the role works as intended, nor can I be accountable for any damage or misconfiguration done by this role. Study the role thoroughly before using it.

## License

MIT

## Author Information

This role was created in 2020 by [Thorian93](http://thorian93.de/).
