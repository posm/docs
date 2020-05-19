################################################################################
For Developers
################################################################################

********************************************************************************
Adding a component
********************************************************************************

The `WebODM Support <https://github.com/posm/posm-build/pull/114>`_ pull request is an example of how to introduce a relatively-complicated component to POSM (it also includes some other, unrelated bug fixes).

However, at its root, adding a component consists of the following steps:

* add relevant settings to ``kickstart/etc/settings`` (and expose them in ``kickstart/etc/posm.json``)
* add a systemd unit file as ``kickstart/etc/systemd/system/<component>.service.hbs``
* add HTTP proxy endpoints in ``kickstart/etc/nginx-posm.conf``
* create ``kickstart/scripts/<component>-deploy.sh`` and ensure that it's executable (``chmod +x <file>``)
* add ``make`` targets to ``live/Makefile`` and reference them in ``posm-core`` (or another relevant target)
* document the name of the component in the README and/or elsewhere

``kickstart/etc/settings``:

.. code-block:: text

  --- i/kickstart/etc/settings
  +++ w/kickstart/etc/settings
  @@ -37,6 +37,7 @@ omk_server_port=3210
   posm_admin_port=3211
   osm_web_port=9000
   cgimap_port=54321
  +thing_port=1234

   # web
   # auth=true # uncomment this to enable web authentication


``kickstart/etc/posm.json``:

.. code-block:: text

  --- i/kickstart/etc/posm.json
  +++ w/kickstart/etc/posm.json
  @@ -30,6 +30,7 @@
     "omk_server_port": "{{omk_server_port}}",
     "osm_web_port": "{{osm_web_port}}",
     "cgimap_port": "{{cgimap_port}}",
  +  "thing_port": "{{thing_port}}",
     "osm_posm_user": "{{osm_posm_user}}",
     "osm_posm_description": "{{osm_posm_description}}",
     "osm_pg_owner": "{{osm_pg_owner}}",


``kickstart/etc/systemd/system/thing.service.hbs``:

.. code-block:: ini

  [Unit]
  Description=The Thing
  # services to start after
  After=docker.service
  # services that need to be running in order to start
  Requires=docker.service

  [Service]
  Restart=always
  ExecStartPre=-/usr/bin/docker kill %n
  ExecStartPre=-/usr/bin/docker rm %n
  # start thing/thing, assuming it listens on :8000 within the container
  ExecStart=/bin/bash -c "docker run \
      --init \
      --rm \
      -p {{thing_port}}:8000 \
      --name %n \
      --tmpfs /tmp \
      posm/thing"

  [Install]
  WantedBy=multi-user.target
  

``kickstart/etc/nginx-posm.conf``:

.. code-block:: text

  --- i/kickstart/etc/nginx-posm.conf
  +++ w/kickstart/etc/nginx-posm.conf
  @@ -53,6 +53,10 @@ server {

     # proxied locations

  +  location /thing {
  +    proxy_pass http://127.0.0.1:{{thing_port}};
  +  }
  +
     location /tiles {
       proxy_pass http://127.0.0.1:{{tessera_port}};
     }
     

``kickstart/scripts<component>-deploy.sh`` takes the following form where ``<component>`` is ``thing``:

.. code-block:: bash

  #!/bin/bash

  # Ubuntu-specific deployment
  deploy_thing_ubuntu() {
    # pre-download the posm/thing image from Docker Hub
    docker pull posm/thing

    # copy systemd unit into place, replacing template variables in the process
    expand etc/systemd/system/thing.service.hbs /etc/systemd/system/thing.service

    # other files can be copied / expanded into place similarly

    # enable the service so that it will run on subsequent restarts
    systemctl enable thing

    # start the service
    systemctl start thing

    ## add thing to the list of services listed on posm.io

    # load the existing list of apps
    apps=$(jq .apps /opt/posm-www/config.json)

    # append Thing to the list of apps using an icon from https://blueprintjs.com/docs/#icons 
    new_apps=$(cat << EOF | jq -s '.[0] + .[1] | unique'
  $apps
  [
    {
      "name":  "Thing",
      "icon": "hand",
      "url": "//${posm_fqdn}/thing/"
    }
  ]
  EOF
  )

    # load the existing config
    config=$(jq . /opt/posm-www/config.json)

    # write out a new config with the updated list of apps
    cat << EOF | jq -s '.[0] * .[1]' > /opt/posm-www/config.json
  $config
  {
    "apps": $new_apps
  }
  EOF
  }

  deploy thing


``live/Makefile``:

.. code-block:: text

  --- i/live/Makefile
  +++ w/live/Makefile
  @@ -155,7 +155,12 @@ telegraf: influxdb
      lxc snapshot $$(cat container) $@
      touch $@

  -posm: base nodejs ruby gis mysql postgis nginx osm fieldpapers omk tl carto tessera admin samba blink1 docker redis opendronemap imagery wifi influxdb telegraf
  +thing: base
  +   lxc exec $$(cat container) -- /root/posm-build/kickstart/scripts/bootstrap.sh $@
  +   lxc snapshot $$(cat container) $@
  +   touch $@
  +
  +posm: base nodejs ruby gis mysql postgis nginx osm fieldpapers omk tl carto tessera admin samba blink1 docker redis opendronemap imagery wifi influxdb telegraf thing
      lxc exec $$(cat container) -- apt upgrade -y
      lxc exec $$(cat container) -- apt-get autoremove -y
      lxc snapshot $$(cat container) $@


With these (or similar) patches applied, the component can be included in a POSM install by running ``kickstart/scripts/bootstrap.sh -x thing`` (the ``-x`` helps debug potential problems).

To confirm that settings were set properly, run ``jq .thing_port /etc/posm.json``.

To stream systemd logs for the ``thing`` service, run ``journalctl -fu thing``.

To ensure that it's running within Docker, run ``docker ps | grep thing.service``.

To see potential nginx syntax errors, run ``journalctl -fu nginx``.