######################
Returning from mapping
######################

.. todo:: This section is being edited and updated. Please let us know if you find any errors or omissions. 

When you're ready, collected data should be cleaned and uploaded to OSM. Between the time you created the AOI export to the time you are ready to push the data back, OSM users in online environments may have created changes to the map. Rather than overwriting those changes, you will need to go through a conflict detection and resolution process. 

Ideally, you can do iterative mapping: use iD and JOSM to edit the OSM database extract stored locally on the POSM, render new deployment files and tiles, collect more data with Field Papers and OpenMapKit, and repeat. The accumulated edits would then need to be transferred from your local OSM to online OSM. To handle this, we've developed POSM replay.

********************************************************************************
OMK Server > JOSM > OSM
********************************************************************************

You can clean the data exported from OpenMapKit Server and upload to OSM (resolving conflicts while doing so) using JOSM.

For large amounts of data, there are certain tools and processes that can streamline data cleaning. We documented our `data cleaning workflow <https://github.com/AmericanRedCross/workflows/blob/master/west-africa_data-cleaning.md>`_ for a project in West Africa. This is project-specific but may be useful in guiding the development of your own workflow.

Here's a short summary:

1. Retrieve the ``.osm`` file from OMK server and open in JOSM. Enable the
   ToDoList and OpenData plug-ins for JOSM.
2. Purge non-relevant features (features that don't need to be cleaned, or
   features outside a geographic area where you want to focus) using
   ``CTRL+Shift+P``. **Do not delete these features**.
3. Save the points and polygons as separate files.
4. For point data: Clean any free-form text inputs. When entering data for
   things like hospital names, town names, etc, enumerators sometimes use
   different spelling of capitalization or include a typo. Use Open Refine to
   clean these columns individually. Open Refine looks for responses that are
   close but not exactly the same, and allows you to group these and change them
   to a consistent spelling. Once you're finished, export as a ``.csv`` file and
   re-open in JOSM (``File -> Open``, accept the coordinate system as WGS84). Make
   sure the points appear to be in the correct place, add a source tag to all
   your new features (e.g. ``source=Red Cross survey``), then push the
   changes to OSM.
5. For polygon data: This is more tedious. Open Refine doesn't play nice with
   XML input, so in the past we've cleaned the individual records in JOSM.
   There's room here for scoping out other data cleaning services or scripts
   that might make it easier to convert from XML into a format that can be
   digested through Open Refine and back again. Once you've cleaned the
   polygons, add the source tag (see step 4), address any validation errors that
   occur, and push to OSM.
6. Save the ``.osm`` files you uploaded, for future reference.

These steps will push changes to the OSM data kept on your local POSM. This
means that you can create new Field Papers, OMK surveys, etc, which will
incorporate these changes for future rounds of mapping.

The local OSM copy is still separate from the online version, however, and will
need to be reconciled and synched when you return from the mapping area to an area with
internet connectivity.

********************************************************************************
POSM replay
********************************************************************************

We've never had a full workflow wherein people edited the local OSM database on the POSM via the iD editor and then needed to get it off. Some potential options are:

- download a snapshot of current data from the API querying the full AOI bounds - if done in JOSM, this can be loaded into a layer and either saved out or individual features copied into an OSM-backed layer
- download OSC changes for each edit made (this is what the POSM Replay Tool does)
- generate an OSM XML / PBF dump using Osmosis against the API DB (using the command line)
- generate an OSM XML history dump using planet-dump-ng against pg_dump output (using the command line)
- gather minutely diffs from http://posm.io/replication/ (these are used for updating the rendering database)

The POSM replay tool is intended to provide an efficient workflow, but requires some command line knowledge and familiarity with GitHub. `Reach out <https://twitter.com/awesomeposm>`_ if you get to this step and need some pointers.

The `complete instructions <https://github.com/americanredcross/posm-replay-tool>`_ and you can `read more <https://hi.stamen.com/merging-offline-edits-with-the-posm-replay-tool-2f39a4410d2a#.47nht8th2>`_ about the concepts and mechanics behind the process.

In general, the replay process works as follows:

1. Obtain an AOI extract (PBF or XML) corresponding to the point where the local OSM API branched from. (This is the PBF file you created through the AOI export and used to set up your POSM deployment )
2. Gather local changesets.
3. Initialize a git repository containing locally-modified entities present in the AOI extract.
4. Obtain an AOI extract containing current data from your upstream (use export.posm.io and follow the same steps you did to create your POSM deployment in the first place... but with current data).
5. Extract and apply changes to locally-modified entities from the current AOI extract.
6. Create a branch representing the local history by applying all local changesets to a branch containing the starting AOI extract.
7. Apply each local changeset to the branch containing the current AOI extract.
8. Manually resolve merge conflicts between local and upstream edits.
9. Submit resolved changesets to your upstream API, renumbering references to locally-created entities as necessary.

We are still improving and fine-tuning this part of the POSM workflow, and we would be interested in your feedback and experience with it.
