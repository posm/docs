########
Overview
########

.. _Field Papers: http://fieldpapers.org

.. todo:: This section is being edited and updated. Please let us know if you find any errors or omissions. 

The American Red Cross typically uses cloud-based mobile apps for its mapping work. These tools require an internet or cell phone connection to create, modify, or troubleshoot mapping surveys, and to upload data periodically. We sometimes need to conduct projects in areas without dependable internet or cellular connectivity, where those mapping may have to be offline for days or weeks at a time. To bridge that gap, we developed POSM (Portable OpenStreetMap) - letting us conduct major field efforts and work entirely offline for months at time. POSM integrates best-of-breed tools from a variety of sources and developers on a single hardware device that can be deployed for mapping efforts, particularly when internet access is absent. 

POSM broadcasts a wireless signal that other devices can connect to in order to locally access tools that ordinarily require an internet connection. POSM let's you bring the standard toolset along for the ride when you don't have access to cheap and fast internet connectivity.

Currently, POSM includes support for GIS and mapping tools used by the Missing Maps project:

* offline `OpenStreetMap <https://www.openstreetmap.org>`_
* editing (using `iD <https://www.openstreetmap.org/edit?editor=id>`_, `JOSM <https://josm.openstreetmap.de/>`_, and other parts of the OSM ecosystem)
* paper-based field mapping (`Field Papers`_)
* field enumeration using mobile devices (OpenMapKit)
* drone imagery processing (`WebODM <https://github.com/OpenDroneMap/WebODM#readme>`_ / `OpenDroneMap <http://opendronemap.org>`_)  
* file-sharing

Wish list of functionality:

* mapper coordination (using the `HOT Tasking Manager <http://tasks.hotosm.org>`_)
* any tools to make the work of a disconnected humanitarian easier - have ideas? get in touch!

POSM can also include software downloads and other useful apps for mapping and mobile data collection:

* `QGIS <http://www.qgis.org_en/site/index.html>`_ (open source desktop GIS)
* `OpenRefine <http://openrefine.org>`_ (desktop data cleaning)
* `OsmAnd <http://osmand.net/>`_ (navigation and GPX-recording app)
* `OpenSignal <https://opensignal.com/>`_ (crowdsourced cell signal-strength recording)
* `AppLock <https://play.google.com/store/apps/details?id=com.domobile.applock&hl=en>`_ (to prevent volunteers from using up cell data for social networking, etc)

This means that any or all parts of a mapping workflow can happen offline. A user can pre-download files for an area of interest and then transport POSM to the area. Mappers can do any and all of the following: fly a drone, process the imagery, use that to conduct a mapathon and create a base map, conduct a phone-based survey, add local detail to the base map with either paper-based or mobile phone-based methods, and pull the resulting data from the phones onto a local server. This cycle can be repeated over and over again to build off of previous efforts. When a project finishes, users take POSM back to an area with internet and push the data to OpenStreetMap and other relevant places.

*************
POSM workflow
*************

.. image:: /img/posm/intro/workflow.png

POSM has been used for mapping Liberia, Sri Lanka, Comoros, Ecuador, and Seattle. It also has potential for use as a secure data-sharing tool (e.g. local intranet for disconnected areas) and many other applications. Additional software can be integrated into the devices.

***************
Getting started
***************

Interested in using POSM? This site walks through all the steps for obtaining, setting up, and using the device. If you are not sure whether or not POSM is right for your project, you can `contact us <https://twitter.com/awesomeposm>`_ and we can talk it through with you.

Please note that the POSM software is free and open-source; the American Red Cross developed this for its own projects but we are happy for others to benefit from it. We do not sell the devices, nor do we make a profit on the technology.

The `OpenStreetMap data model <http://wiki.openstreetmap.org/wiki/Elements>`_ (nodes, ways, relations) is POSM’s lingua franca. Many formats may be derived from it, but all are assumed to be lossy in some way or another.

OSM XML and PBF formats are effectively interchangeable, but we prefer OSM PBF for its substantially smaller file size (and roughly equivalent tool support).

Once data has been loaded into the system (from export.posm.io as an OSM PBF), OSM’s API DB becomes the source of truth, as it retains the OSM data model and captures historical editing activity. It can be relatively easily converted to OSM PBF (using Osmosis) in order for other tools to create derivative forms (e.g. osm2pgsql updating a rendering database for posm-carto to use). This actually occurs periodically as part of the backup process.

**********
Components 
**********

POSM is built on top of Ubuntu 18.04 LTS and incorporates the following pieces:

* Admin - `posm-admin <https://github.com/AmericanRedCross/posm-admin>`_, POSM’s administrative interface and data provisioning tool
* Bridge - bridged networking support--allows POSM devices to be used as conventional WiFi hotspots
* Captive - captive portal mode--prevents clients from accessing the internet while surfacing locally-available POSM services
* Carto - `posm-carto <https://github.com/AmericanRedCross/posm-carto>`_, a TileMill style intended to highlight data present in OSM following the `Humanitarian Data Model <http://wiki.openstreetmap.org/wiki/Humanitarian_OSM_Tags>`_
* CGImap
* Field Papers - an offline-tuned `Field Papers`_ instance
* GIS - Miscellaneous command-line GIS tools (GDAL et al)
* iD Editor
* MySQL - MySQL server (required by Field Papers)
* Nginx - HTTP server and reverse proxy
* NodeJS - Node.js runtime (required by other components)
* OMK - `OpenMapKit Server <https://github.com/posm/OpenMapKitServer>`_
* OSM - an `offline-tuned OpenStreetMap <https://github.com/posm/openstreetmap-website>`_ instance
* PostGIS - PostgreSQL server with PostGIS (required by OSM)
* Ruby - Ruby runtime (required by Field Papers and OSM)
* Samba - SMB fileshares
* Tessera - Map tile server (renders posm-carto and MBTiles archives that have been provided)
* TL - Command-line map tile Swiss Army knife
* WiFi - access point support--allows POSM devices to be connected to wirelessly


Ubuntu
======

We chose to build on Ubuntu 14.04 both for its long-term support and because it's relatively-well supported by open source GIS tools that we use to glue components together.

For pragmatic reasons (which were valid at the start of the project, if not today), POSM is
primarily provisioned using a set of shell scripts (which can be used to preseed ``debian-installer``
when installing from a USB stick) that download and configure each software component, typically
preferring the native packaging system for each underlying software platform (e.g. RubyGems with
``bundler``, ``npm``, and ``pip`` with ``virtualenv``) rather than creating Debian packages which would need to be maintained separately for each.

An additional reason for using platform-native packaging systems is that they tend to do a better
job of isolating differing dependencies from other components (at the expense of disk space), which
is important for POSM, as we have little control over what our service dependencies require.

In some cases, system-wide versions are in use, e.g. Ruby, Python, and Node.js.

The individual "deploy" scripts in ``posm-build`` are generally intended to be runnable multiple times
without causing problems. Warnings and errors may be output, but they generally occur when a command
that can only produce a single effect is run more than once, e.g. user creation. However, in some
cases, data may be deleted, particularly when databases are (re-)configured.

openstreetmap-website
=====================

We use a lightly customized version of openstreetmap-website (see the ``posm`` branch) to allow data
to be browsed and edited. The bulk of local modifications are to facilitate offline usage (disabling
functionality in certain places and reconfiguring map layers) and simplified editing (preventing
users from needing to log in). Additional modifications involve configuring the application to run
behind Nginx (using Puma).

CGImap
======

Like openstreetmap.org, we use CGImap to serve the bulk of API calls. We use it unmodified.

iD Editor
=========

POSM maintains some minor local modifications to the iD editor. These consist of disabling
functionality that requires internet access (e.g. Nominatim (geocoding) and Taginfo (statistics +
info about how tags are used)) and configuring available background layers.

OpenMapKitServer
================

OpenMapKitServer is a Node.js-based OpenDataKit (ODK) Aggregate-compatible server with additional
functionality that allows OSM edits to be synchronized directly to an API endpoint. When used with
POSM, edits are submitted to the local API instance (typically ``http://osm.posm.io/``).

Field Papers
============

Field Papers runs unmodified, as necessary configuration hooks were built in during POSM
development. Notable changes relative to fieldpapers.org include the use of local disks (versus S3) for
storage of PDFs, GeoTIFFs, and uploaded snapshots, a web hook configured to notify POSM admin (or
OMK Server?) when atlases have been created, and exposure of an SMB share that allows snapshots to
be uploaded in bulk by copying them to a fileshare.

TODO create a Field Papers section in "Use" / "Operation"

TODO elaborate on the effect of the web hooks

TODO elaborate on how snapshots can be uploaded in bulk

TODO highlight CSV grids

posm-carto
==========

TODO discuss HDM support

TODO discuss worldwide locator map

TODO mention slowness

TODO ``service tessera restart`` after loading new data

posm-admin
==========

TODO


.. todo:: This following needs to rewritten and modified so it makes sense in the larger scheme of the docs.


********************************************************************************
History
********************************************************************************

Philosophy
================================================================================

When faced with the decision of whether to create a new tool to achieve a well-defined goal, we have opted to use or adapt existing solutions and create glue components that allow them to work together with other tools that have already been incorporated into POSM. As POSM is primarily about collecting and improving geographic data that exists within OpenStreetMap, the OSM ecosystem is the source of first choice.

We would rather adapt existing tools and combine them with others to achieve goals rather than write (and support) our own. Software that supports POSM should be Open Source if at all possible.

“Small pieces loosely joined” describes the world we map and develop software within; therefore, it should also describe the systems we build.

OpenStreetMap’s data model may appear unconventional, but the tools developed within that paradigm are generally more user-centric than more typical GIS analysis tools.

Genesis
================================================================================

The idea of the POSM came at the `HOT Summit 2015 <http://wiki.openstreetmap.org/wiki/HOT_Summit>`_ at the `American Red Cross headquarters <http://www.openstreetmap.org/way/66409265#map=19/38.89636/-77.04556>`_ in Washington, DC. Here we presented the first release of OpenMapKit. At that time, OpenMapKit only had the Android component. We were relying on a 3rd party ODK Aggregate server in the cloud to submit survey data. This solution was a great start, and it served our needs when we had a good internet connection at the base camp of an urban survey.

The primary use case of OpenMapKit is to enable a fleet of volunteers to check out a phone and survey an assigned area. This is a standard Missing Maps workflow used by the Red Cross, World Bank, Doctors Without Borders (MSF), and other NGOs. It is a big, all day event, where people come together and enhance OpenStreetMap for a given community.

We use a suite of tools to get the job done, and we typically have 30+ volunteers involved. We gather data in the field both with OpenMapKit and Field Papers, and when we return to base camp, we validate and submit this data ultimately to OpenStreetMap.

Usually this work is conducted in vulnerable communities in developing countries. When we are working in an urban area, we can usually find an internet connection, but the reliability and bandwidth is often very limited. When 30+ people try to access OpenDataKit and OpenStreetMap services in the cloud, **the internet connection is guaranteed to grind to a halt!**

In fact, this problem presents itself everywhere, including the Red Cross HQ in Washington, DC. Further, groups such as the MSF conduct surveys in very remote, rural areas. The team will go days without an internet connection; cloud services are simply **out of reach**.

The question at hand is: How do you sync data to the cloud when you are somewhere so remote that internet access is simply not an option?


Inspiration
================================================================================


We are not the only ones using OpenDataKit to collect data. In fact, ODK is the most widely used data collection tool for mobile electronic surveys. There is a large ecosystem of tools and services, and it has become a standard. For years people have been gathering GPS points using this tool, and OpenMapKit's primary contribution is the ability to collect OSM data and directly tag OSM data from the Android app.

At the 2015 HOT Summit, we encountered several organizations that use ODK, and the one pioneer in particular that stuck out was Ivan Gayton from Doctors Without Borders.

Ivan had a backpack full of `Intel Edisons <https://en.wikipedia.org/wiki/Intel_Edison)>`_, a tiny, low power embedded system that runs linux and has integrated wifi. With 4 GB of SSD space and a 500Mhz dual core Intel Atom CPU, we don't have very much power, but it is more than enough to power an ODK Aggregate Server.

Ivan, having lead the OSM mapping effort in `Lubumbashi, DRC <http://www.openstreetmap.org/node/27564973#map=12/-11.6712/27.5125>`_ and other areas in Sub-Saharan Africa, was interested in using OpenMapKit, but he would need a solution that fully functions offline. So, to explore this concept, we took our computers outside, plugged in a fresh Intel Edision into our USB ports, and installed the classic `ODK Aggregate <https://opendatakit.org/use/aggregate/>`_. After 45 minutes of admin, we got it running. And, we were able to submit OSM data in a survey from OpenMapKit to the device.

Putting it All Together
================================================================================

As I continued working with the Red Cross, `SpatialDev <http://spatialdev.com/>`_ entered a new phase of work--a project to bring OpenMapKit to the next level. The initial impetus for me was to build a server-side component for OpenMapKit, a simple web service for users to submit their survey data. Still, we wanted to have a deeper integration with OpenStreetMap tools. And, the offline problem had to be solved with more than just OpenDataKit. To achieve this goal, we began a partnership with `Stamen Design <http://stamen.com/>`_, the creator of `Field Papers`_. The premise: integrate OpenMapKit with Field Papers to create a single, cohesive experience.

The workflow used in `Missing Maps <http://www.missingmaps.org/>`_ surveys and mapathons involves a suite of many open source software components. The initial idea was to use the Intel Edison as the server component for our simple ODK Aggregate server, now called OpenMapKit Server. In fact, OpenMapKit Server runs quite well on the Intel Edison. Our goal, however, was larger--we wanted to run our own OpenStreetMap server, as well as Field Papers on our low powered device.

More Power
================================================================================

Running our own OpenStreetMap using existing software requires a bit more horsepower than the Intel Edison provides. We began a software integration process, now solidified as POSM Build, on several pieces of hardware: the `Raspberry Pi <https://en.wikipedia.org/wiki/Raspberry_Pi>`_, the `Brck Pi <http://www.brck.com/2014/11/brckpi/>`_, as well as the `Intel NUC <https://en.wikipedia.org/wiki/Next_Unit_of_Computing>`_. Long story short, we needed more power than the Pi had to offer, and the Intel NUC was just right.