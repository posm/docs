############
Installation
############

.. todo:: Need to revise and add more details to this section.

*************
Prerequisites
*************

You'll need the latest version of both ODK Collect and OpenMapKit on your Android device. OpenMapKit currently supports Android version 4.2 and higher. You will also need install OpenMapKit Server in order manage surveys and OSM data, deploy them to your Android devices and submit surveys back to OSM.


ODK Collect
===========

You can either download ODK Collect on the `Google Play Store`_ or directly download the `APK <https://opendatakit.org/downloads/download-category/collect/>`_.


OpenMapKit
==========

Once ODK Collect is installed download OpenMapKit from the `Google Play Store`_ or `get the APK <https://github.com/AmericanRedCross/OpenMapKitAndroid/releases>`_.

.. _Google Play Store: https://play.google.com/store/apps/details?id=org.odk.collect.android

OpenMapKit Server
=================

Once ODK Collect and OpenMapKit are on your Android device, install OpenMapKit Server on an environment of your choosing.

For an actual deployment of OpenMapKit Server, it is recommended to use
`posm-build <https://github.com/AmericanRedCross/posm-build>`_ to install your
instance. posm-build is a lightweight shell build system used for POSM servers.
OpenMapKit Server is designed to be a part of a POSM server, however, the
posm-build allows you to be modular regarding what gets installed, so you can
and should use it if you want to install a standalone OpenMapKit Server.

The advantage is that in a few lines, you can have OpenMapKit Server installed
and integrated as an Upstart service in Ubuntu Linux. This means that if
OpenMapKit Server crashes or is restarted, the API will restart automatically.
Also, posm-build only gets the dependencies you need and downloads only the
files you need, so the entire repo does not need to be cloned with git.

.. todo:: All of these install instructions need to be updated.

Instructions for `installing OpenMapKit Server <https://github.com/AmericanRedCross/OpenMapKitServer/blob/master/docs/development-installation.md>`_ on your development environment.


Tested On
---------

* Amazon EC2 Ubuntu Server 14.04 LTS
	- Instance Type: t2.nano
	- vCPUs: 1
	- Memory: 500 MB
	- Storage: 8 GB
	- Open Ports: 22, 80, 3210

OpenMapKit Server is intended to be as light-weight as possible, so you don't
have to throw much hardware at it.


Steps
-----

1. Download and extract posm-build.

.. code-block:: bash 

  sudo -s
  wget -q -O - https://github.com/AmericanRedCross/posm-build/archive/master.tar.gz | tar -zxf - -C /root --strip=2

2. Create a `settings.local` file in `/root/etc` with the following content:

.. code-block:: bash

  posm_ip="54.191.109.128"

 Replace the IP address for `posm_ip` with the actual public IP or your server. If you are on Amazon, this should be your Elastic IP.

3. Execute `bootstrap.sh` and tell it to only install NGINX and OpenMapKit Server.

.. code-block:: bash

  /root/scripts/bootstrap.sh base virt nodejs nginx omk

Let the installation churn. That's it!


Upstart
-------

You can start / stop / restart the `omk-service` like any Ubuntu Upstart service.

.. code-block:: bash

  sudo service omk-server stop
  sudo service omk-server start
  sudo service omk-server restart


Your Data
---------

All of your data are stored in `/opt/omk/OpenMapKitServer/public`.

You can scp / sftp the

forms `/opt/omk/OpenMapKitServer/public/forms`

deployments `/opt/omk/OpenMapKitServer/public/deployments`

submissions `/opt/omk/OpenMapKitServer/public/submissions`

from the server to backup and access your data. There is no database, so all of your data are in these files.