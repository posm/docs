<<<<<<< HEAD
# Mobile Data Collection Website

## Overview

* Documentation for POSM and Open Map Kit
* This website is created with the Hugo static site generator. See https://gohugo.io and https://github.com/gohugoio/hugo.
  - Hugo can be installed with prebuilt binaries for popular operating systems. You can also build your own binaries from source
  - See https://gohugo.io/getting-started/installing/ for information
* The site uses the docDock Hugo theme. See https://themes.gohugo.io/docdock/ and https://github.com/vjeantet/hugo-theme-docdock
  * DocDock is currently installed as a submodule. This can be changed if it causes more problems than it solves
  * If the themes/dockdock folder is empty, the following git command should populate the folder:
  ```
  git submodule update --init --recursive
  ```
* The site uses out-of-the-box functionality and does not make changes to the Hugo or docDock codebase.

## How to Manage Content

* Focus is separating presentation from content
  1. All MarkDown is located in the content directory
  1. Static resources, such as images or css go into the static directory
  1. Site navigation is inferred from the structure of the content folder. For example, the POSM section of the site is created from content/POSM

## Customizing the Presentation

* Focus on using the capabilities of the theme as-is or only using the theme's extension mechanisms
* Adding additional JavaScript or css resources is a 2 step process:
  1. Add a reference in layouts/partials/custom-head.html. This will be automatically included in the generated HTML
  1. Any referenced files specified in layouts/partials/custom-head.html should be included in the static directory
  1. An example is the inclusion of the static/css/redcross-custom.css. This example includes css that changes the default color of the docDock theme header
* Substantial changes to the presentation may require more extensive changes to the supplied CSS than is easily accommodated with this mechanism. The DocDock documentation references supplying a replacement "theme.css" but this documentation is apparently out-of-date or incorrect.
=======
# docs
documentation for POSM and OMK
>>>>>>> 4a7631ee6533b60022e65d2ae520cc09ed4d5e90
