## Docs

Hello. Thanks for stopping by. This is a work in progress.

## Development

### Section hierarchy

```

#########
Heading 1
#########

*********
Heading 2
*********

Heading 3
=========

Heading 4
---------

Heading 5
^^^^^^^^^

```

### Environment

_(on OSX)_

```bash
# install git lfs  
# https://git-lfs.github.com/
brew install git-lfs
git lfs install
# install python
brew install python3
# install virtualenv
pip install virtualenv
# create Python environment
virtualenv -p /usr/local/bin/python3 venv
# open the Python environment
source venv/bin/activate
# install requirements
pip install -r requirements.txt
```

More on [`virtualenv`](https://virtualenv.pypa.io/en/stable/).

Use [`sphinx-autobuild`](https://github.com/GaretJax/sphinx-autobuild) to automatically watch for changes and rebuild the html site using:
```
make livehtml
```

To stop the server press `Ctrl+C`.

### Travis-CI

You'll need to [install](https://github.com/travis-ci/travis.rb#installation).
Check out the Travis-CI docs for [Building a Python Project](https://docs.travis-ci.com/user/languages/python/) and [GitHub Pages Deployment](https://docs.travis-ci.com/user/deployment/pages/). Personal access token with 'public_repo - Access public repositories' permissions created and used it in `travis encrypt GH_TOKEN=my_github_token --add env.matrix` as described in the [Travis-CI docs](https://docs.travis-ci.com/user/environment-variables#Encrypting-environment-variables).