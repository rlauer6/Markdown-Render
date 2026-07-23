# Table of Contents

* [NAME](#name)
* [SYNOPSIS](#synopsis)
* [DESCRIPTION](#description)
* [METHODS AND SUBROUTINES](#methods-and-subroutines)
  * [new](#new)
  * [finalize\_markdown](#finalize\markdown)
  * [render\_markdown](#render\markdown)
  * [print\_html](#print\html)
* [AUTHOR](#author)
* [LICENSE](#license)
* [SEE OTHER](#see-other)
# NAME

Markdown::Render - Render markdown as HTML

# SYNOPSIS

    use Markdown::Render;

    my $md = Markdown::Render->new( infile => 'README.md');

    $md->render_markdown->print_html;

...or from the command line to create HTML

    md-utils.pl -r README.md > README.html

...or from the command line to replace render custom tags

    md-utils.pl README.md.in > README.md

# DESCRIPTION

Renders markdown as HTML using either GitHub's API or
[Text::Markdown::Discount](https://metacpan.org/pod/Text%3A%3AMarkdown%3A%3ADiscount). Optionally adds additional metadata to markdown
document using custom tags.

See
[README.md](https://github.com/rlauer6/markdown-utils/blob/master/README.md)
for more details.

_Note: This module originally used [Text::Markdown](https://metacpan.org/pod/Text%3A%3AMarkdown) as an
alternative to using the GitHub API however, there are too many bugs
and idiosyncracies in that module. This module will now use
[Text::Markdown::Discount](https://metacpan.org/pod/Text%3A%3AMarkdown%3A%3ADiscount) which is not only faster, but seems to be
more compliant with GFM._

_Note: Text::Markdown::Discount relies on the text-markdown library
which did not actually support all of the markdown features (including
code fencing).  You can find an updated version of
[Text::Markdown::Discount](https://metacpan.org/pod/Text%3A%3AMarkdown%3A%3ADiscount) here:
[https://github.com/rlauer6/text-markdown-discount](https://github.com/rlauer6/text-markdown-discount)_

# METHODS AND SUBROUTINES

## new

    new( options )

Any of the options passed to the `new` method can also be set or
retrieved use the `set_NAME` or `get_NAME` methods.

- css

    URL of a CSS file to add to head section of printed HTML.

- engine

    One of `github` or `text_markdown`.

    default: github

- git\_user

    Name of the git user that is used in the `GIT_USER` tag.

- git\_email

    Email address of the git user that is used in the `GIT_EMAIL` tag.

- infile

    Path to a file in markdow format.

- markdown

    Text of the markdown to be rendered.

- mode

    If using the GitHub API, mode can be either `gfm` or `markdown`.

    default: markdown

- no\_title

    Boolean that indicates that no title should be added to the table of
    contents.

    default: false

- title

    Title to be used for the table of contents.

## finalize\_markdown

Updates the markdown by interpolating the custom keywords. Invoking this
method will create a table of contents and replace keywords with their
values.

Invoke this method prior to invoking `render_markdown`.

Returns the [Markdown::Render](https://metacpan.org/pod/Markdown%3A%3ARender) object.

## render\_markdown

Passes the markdown to GitHub's markdown rendering engine. After
invoking this method you can retrieve the processed html by invoking
`get_html` or create a fully rendered HTML page using the `print_html`
method.

Returns the [Markdown::Render](https://metacpan.org/pod/Markdown%3A%3ARender) object.

## print\_html

    print_html(options)

Outputs the fully rendered HTML page.

- css

    URL of a CSS style sheet to include in the head section. If no CSS
    file option is passed a default CSS file will b used. If a CSS element
    is passed but it is undefined or empty, then no CSS will be specified
    in the final document.

- title

    Title to be added in the head section of the document. If no title
    option is passed the name of the file will be use as the title. If an
    title option is passed but is undefined or empty, no title element
    will be added to the document.

# AUTHOR

Rob Lauer - rlauer6@comcast.net

# LICENSE

This software is licensed under the same terms as Perl.

# SEE OTHER

[GitHub Markdown API](https://docs.github.com/en/rest/markdown)
[Text::Markdown::Discount](https://metacpan.org/pod/Text%3A%3AMarkdown%3A%3ADiscount)
