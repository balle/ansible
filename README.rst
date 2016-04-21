Run locally without ssh
=======================

.. code-block: bash
  
  ansible-playbook -c local workstation.yml


Run remote over ssh
===================

* Add your host(s) to the hosts file

.. code-block: bash

  ansible-playbook -k workstation.yml 