# Mackerel

## install https://brew.sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

##
brew install imagemagick

## usage
`cd album`
`ls album`
- originals (contains JPGs)
`./mackerel.sh`
`ls album`
- originals (unchanged)
- thumbnails (contains 300x300 jpgs)
- photos (contains optimized JPGs)
- book (contains HTML wrappers)
- index.html
