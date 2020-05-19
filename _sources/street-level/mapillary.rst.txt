################################################################################
Mapillary
################################################################################

.. todo:: Need to revise and add more details to this section.

Mapillary is great for adding `additional detail to OpenStreetMap <https://www.mapillary.com/osm>`_. Check the `Mapillary help pages <https://help.mapillary.com>`_ for the most up-to-date information, and the `community forum <https://forum.mapillary.com/>`_ is a great place to ask questions and get in touch with other contributors.

********************************************************************************
Contributing
********************************************************************************

Mapillary strongly suggests that you review and remove all bad-quality and/or sensitive images before upload. It is possible to delete images post-upload, but doing it beforehand will always be quicker and more effective.

Check out this help article on a variety of `different upload methods <https://help.mapillary.com/hc/en-us/articles/115001472029-Different-upload-methods>`_. Uploading is easy if you're using the phone app. Their `web uploader <https://help.mapillary.com/hc/en-us/articles/115001663165>`_ is convenient for uploading smaller batches (up to ~1,000) of geotagged images taken outside of the Mapillary app. Their recently released desktop uploader looks interesting but we're waiting for a few additional features before we start using it regularly (as of 2019-01-27). 

Upload scripts
================================================================================

Our workflow is usually to set a camera on an interval mode and forget about it, so we need rely on upload scripts which provide necessary functionality such as duplicate removal for the repeat photos taken when the vehicles is in traffic or stops at a light. The `mapillary_tools <https://github.com/mapillary/mapillary_tools#readme>`_ repository on GitHub has detailed instructions for installing and using the tools.

We use the ``--advanced`` flag along with ``--interpolate_directions --offset_angle 90`` for right facing cameras for ``--interpolate_directions --offset_angle 270`` for left facing cameras.
