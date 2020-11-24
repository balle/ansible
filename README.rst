Run locally without ssh
=======================

.. code-block:: bash
  
  ansible-playbook -c local workstation.yml


Run remote over ssh
===================

* Add your host(s) to the hosts file

.. code-block:: bash

  ansible-playbook -k workstation.yml 

  
Run only one tag locally
========================

.. code-block:: bash
  
  ansible-playbook -c local -t base workstation.yml

  
Run all but some tags locally
=============================

.. code-block:: bash
  
  ansible-playbook -c local --skip-tags desktop,office workstation.yml

