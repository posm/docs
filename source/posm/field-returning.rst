########################
Returning from the field
########################

.. todo:: This section needs to be edited and updated for the most recent release of POSM.

When you've completely finished with a field project (or are returning to periodic internet use), the following steps need to happen:

1. OMK data should be cleaned and uploaded to local OSM (see 'In the field' section)
2. Edits to local OSM (from iD, JOSM, and OMK) must be pushed to online-OSM. Between the time you created the AOI export to the time you are ready to push the data back, OSM users in online environments may have created changes to the map. Rather than overwriting this, you will need to go through a conflict detection process. To handle this, we've developed what we call the "POSM replay tool".

****************
POSM replay tool
****************

The POSM replay tool requires some command line knowledge and familiarity with GitHub. `Reach out <https://twitter.com/awesomeposm>`_ if you get to this step and need some pointers.

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
