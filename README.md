# Mackerel

## Goal

Create a tool that generates static photo albums.
The tool should work for as long as possible with minimum maintenance or dependencies.

## Dependencies

- Browser that supports HTML & JPEG (JS optional)
- ImageMagick JPEG encoder
- Bash, echo, cat, ... (reading directories)
- Optionally a static web host. e.g. S3

## Install

`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

`brew install imagemagick`

## Use
`cd album`

`ls`:

- originals (contains JPGs)

`./mackerel.sh`

`ls`:

- originals (unchanged)
- thumbnails (contains 300x300 jpgs)
- photos (contains optimized JPGs)
- book (contains HTML wrappers)
- index.html
