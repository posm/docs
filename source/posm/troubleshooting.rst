#######################
General troubleshooting
#######################

.. todo:: This section is being edited and updated. Please let us know if you find any errors or omissions. 

We've noticed a few errors (or noticed ourselves making user
errors) when using POSM. Here's a quick list of some of these issues and how to solve
them.


First-time POSM install fails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Did you prepare the USB stick, plug it into POSM, and try to boot... only to get
an error message? This can be an issue if your USB stick has an overall folder
that contains everything that you extracted from the POSM `.iso` file. It can
also be an issue if you extracted the files and then moved them manually onto
the USB stick. There are hidden files in the package which will not follow if
you try to manually move the contents. You can fix this by using an extraction
tool (like The Unarchiver for Mac or 7-Zip for Windows) to extract the contents
directly onto the USB stick.

Re-installing the core POSM software
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Let's say there's a new version of the POSM stack and you want to upgrade. You
can do this by following the normal first-time install process: download
software, prep USB stick, install onto POSM. The software will overwrite and
previous versions.

I'm connected to POSM. When I try to reach any website, it should redirect me to posm.io but it sometimes doesn't
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



Secure websites (ie websites whose URL starts with https:// instead of http://)
will not redirect to the posm.io homepage. So, if you click any link in your
bookmarks, it may not redirect to posm.io.

Can I be connected to the internet and POSM at the same time?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Yes. Plug POSM into Ethernet and, in the admin interface, turn on Bridge Mode.

Can I use encrypted ODK forms to protect sensitive data?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Yes. You will need to download and set up ODK Briefcase to do this.
`Instructions are on the ODK
site <https://opendatakit.org/help/encrypted-forms/>`_. You will need to set up a
public and private key and include the public key in your ODK form. To access
submissions, open ODK Briefcase and `Pull` the submissions, then `Export` them.
You will get a `.csv` file with your decrypted data.

Multiple deployments are buggy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

POSM sometimes has a hard time dealing with multiple deployments - it may
struggle when making MBTiles archives, or when first loading a deployment onto
phones. We've solved this by just trying those processes again. It is also a
good idea to keep the POSM "clean" by deleting old deployments that are no
longer needed.

How do I delete an old deployment?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To do this, you will need to use an FTP client like
`Cyberduck <https://cyberduck.io/?l=en>`_ (or command line) to connect (or "SSH")
into POSM.

Power up the POSM and connect to it from your computer. Launch Cyberduck and
start a new connection with the following parameters:

* Type: `SSH`
* Server: `posm.io`
* Username: `root`
* Password: `posm`

.. image:: /img/posm/troubleshooting/cyberduck.png

You will see files under `/opt/data`. Always be extremely careful if deleting
submitting field data.

How do I access the file structure behind POSM?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To do this, you will need to use an FTP client like
`Cyberduck <https://cyberduck.io/?l=en>`_ (or command line) to connect (or "SSH")
into POSM.

Power up the POSM and connect to it from your computer. Launch Cyberduck and
start a new connection with the following parameters:

* Type: `SSH`
* Server: `posm.io`
* Username: `root`
* Password: `posm`

.. image:: /img/posm/troubleshooting/cyberduck.png

.. todo:: The file structure looks like this: (needs completion + screenshot)

I have more than one POSM and I can't connect to the second
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Read on for the answer to the next question.

I reinstalled the POSM software and now I can't connect
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you've got more than one POSM, you will not be able to connect your computer using SSH.
You will get errors accessing `posm.io`, Cyberduck and Terminal won't not connect, etc.

To fix this, open your `known_hosts` file (`~/.ssh/known_hosts`) in a text
editor and delete each row that begins with `posm.local`, `posm.io`, or
`172.16.1.1`. Save the changes and try again.

OMK was working... but stopped. I'm getting error messages from phones and computers.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This has happened when using a public fileshare with a lot of devices. In
Terminal, connect to POSM over SSH (`ssh root@posm.io`, password `posm`) and
then run this command to restart OMK Server: `service omk-server restart`.

Can I push OMK/ODK data to the server through a cell connection or actual internet?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Yes... but it's a little tricky. This would involve creating a parallel server
in the cloud and then integrating this data back into the POSM server. If doing
this is worth it (or just interesting) to you, then `here are the
instructions <https://hackmd.io/EYFhA4DYDMFMEYC0BDEBmYiSXmx4BOAY0iwHZoAGAVnnFkrICYyg>`_.
