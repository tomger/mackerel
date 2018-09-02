#!/bin/bash

while getopts ":n" opt; do
  case $opt in
    n)
      NO_IMAGES=true
      echo "Not generating new images" >&2
      ;;
  esac
done

if [ "$NO_IMAGES" != true ] ; then
  echo "Generating thumbnails for gallery overview"
  mkdir -p thumbnails
  mogrify -format jpg -resize "300x300^" -gravity center -crop 300x300+0+0 +repage -path thumbnails originals/*
  echo "Generating filesize friendly photos"
  mkdir -p photos
  mogrify -quality 98% -auto-orient -thumbnail 1334x750 -format jpg -path photos originals/*
fi

mkdir -p book
cat > "index.html" << EOF
<!DOCTYPE html>
<html><head><title>${PWD##*/}</title>
<style>
body {
  background: #232324;
}
h1 {
  margin: 120px auto 50px auto;
  width: 940px;
  color: #fff;
  text-align: center;
  font-size: 40px;
}
main {
  display: grid;
  grid-template-columns: 300px 300px 300px;
  grid-gap: 10px;
  margin: 10px auto 120px auto;
  width: 940px;
}
img {
  border-radius: 2px;
  box-shadow: 0 1px 1px 0 rgba(0, 0, 0, .25)
}
a { display: flex; }
</style>
</head>
<body>
<h1>${PWD##*/}</h1>
<main>
EOF
declare -a files=(thumbnails/*)
for (( i = 0; i < ${#files[*]}; ++ i ))
do
next=$[i+1]
previous=$[i-1]
photo=$(basename "${files[$i]}")
nextPhoto=$(basename "${files[$next]}")

cat >> "index.html" << EOF
<a href="book/${i}/index.html"><img src="${files[$i]}"></a>
EOF


mkdir -p "book/${i}"
cat > "book/${i}/index.html" << EOF
<!DOCTYPE html>
<html><head><title>Photo</title>
<meta property="og:image" content="../${files[$i]}" />
<link rel="prefetch" href="../${next}/index.html"/>
<link rel="prefetch" href="../../photos/${nextPhoto}"/>
<style>
body {
  background: #121213;
  padding: 0; margin: 0;
  overflow: hidden;
}
img {
  height: 100vh;
  width: 100vw;
  object-fit: contain;
  box-shadow: 0 10px 30px 0 rgba(0, 0, 0, .4)
}
</style>
</head>
<body>
<script>
var currentPicture = ${i};

document.onkeydown = function(event) {
  if (event.keyCode === 39) { // right arrow
    //window.location = "../${next}/index.html";
    currentPicture++;
    let newUrl = "../" + currentPicture + "/index.html"
    history.pushState({}, "Photo", newUrl);
    fetch(newUrl)
      .then(function(response) {
        return response.text();
      })
      .then(function(html) {
        document.body.innerHTML = html;
      })
  } else if (event.keyCode === 37) { // left arrow
    window.location = "../${previous}/index.html";
  } else if (event.keyCode === 27) { // esc
    window.location = "../";
  } else if (event.keyCode === 70) { // F
    document.body.webkitRequestFullscreen();
  }
}
</script>
<a href="../${next}/index.html">
  <img src="../../photos/${photo}"/>
</a>
</body>
</html>
EOF
done

cat >> "index.html" << EOF
</main>
</body>
</html>
EOF
