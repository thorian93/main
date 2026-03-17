============================
thorian93.main Release Notes
============================

.. contents:: Topics

v2.0.0
======

Release Summary
---------------

A well overdue cleanup.

Major Changes
-------------

- Fix tons of linting findings across roles and playbooks.
- Modernize CI. Move all Python calls to ``uv`` and run on Podman.
- Update and clean up OS support.

Minor Changes
-------------

- Clean up old configuration.
- Extend Dependabot coverage.

Known Issues
------------

- I changed a bunch of things, so things might break. While I am using this collection myself, I cannot promise, that I will detect issues myself.
- I did not have the time to summarize all the changes, so expect the unexpected.
- Some tests do still fail, but I want to get this release out and fix subsequent findings when I get the time.

v1.2.0
======

v1.1.0
======

Release Summary
---------------

Trying to keep it clean.

Minor Changes
-------------

- Common role - Skip `/etc/hosts` configuration in containers.
- SSH role - Enable configuration of the`Include` directive.

Bugfixes
--------

- All roles - Fix another batch of linting issues.

v1.0.0
======

Release Summary
---------------

Spring clean!

Major Changes
-------------

- Add webserver role.

Breaking Changes / Porting Guide
--------------------------------

- Common role - Rename variable `shopt_options` to `common_shopt_options`. Please adapt your inventory if necessary!
- SSH role - Change prefix for all variables from `sshd_` to `ssh_`. Please adapt your inventory if necessary!

Bugfixes
--------

- Fix a lot of linting findings across the board.

v0.0.3
======

Release Summary
---------------

Spring clean.

Minor Changes
-------------

- All roles - Add support for Rocky Linux 9.
- Upgrade role - Add trigger for Checkmk APT check.

Removed Features (previously deprecated)
----------------------------------------

- All roles - Remove support for CentOS 7.

v0.0.2
======

Release Summary
---------------

Extending the collection.

Major Changes
-------------

- Add several roles.

v0.0.1
======

Release Summary
---------------

Initial Release of this collection.

Major Changes
-------------

- Add upgrade role.
- Create basic collection layout.
