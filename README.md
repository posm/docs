# Mobile Data Collection Website

## Technical Overview

* This website is created with the Hugo static site generator. See https://gohugo.io
* The site uses the docDock Hugo theme. See https://themes.gohugo.io/docdock/ and https://github.com/vjeantet/hugo-theme-docdock
* The site uses out-of-the-box functionality and does not make changes to the Hugo or docDock codebase.

## How to Manage Content

* Focus is separating presentation from content
1. All MarkDown is located in the content directory
1. Static resources, such as images or css go into the static directory
1. Site navigation is inferred from the structure of the content folder. For example, the POSM section of the site is created from content/POSM

### How to Add / Edit / Delete content

* MarkDown content goes into the content directory
* If the static directory structure matches the content directory structure, then links to static files do not require an absolute or relative path specification
* Removing from the content directory and rebuilding the site will update dependencies

## Customizing the Presentation

* Focus on using the capabilities of the theme as-is or only using the theme's extension mechanisms
* Adding additional JavaScript or css resources is a 2 step process:
1*. Add a reference in layouts/partials/custom-head.html. This will be automatically included in the generated HTML
1. Any referenced files specified in layouts/partials/custom-head.html should be included in the static directory
1. An example is the inclusion of the static/css/redcross-custom.css. This example includes css that changes the default color of the docDock theme header
* The Red Cross themed footer required more extending more of the DocDock framework than is ideal.
1. The footer is generated by a custom HTML file in /layouts/partials/flex/body-aftercontent.html.
2. The footer does not used MarkDown. Compare the footer to the body-aftercontent.html in themes/mdc-docdock/layouts/partials/flex/body-aftercontent.html.
3. Additional scss for the footer is located in /static/scss/footer.scss
