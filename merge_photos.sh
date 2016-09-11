for f in /Users/Nick/dev/us-of-color/photos/*;
  do
    echo "${PWD##*/}"
    cd $f
    rm out.jpeg
    convert -append *.jpeg out.jpeg
    # cd ..
    #  [ -d $f ] && cd "$f" && echo Entering into $f and installing packages
  done;

#
#   curl -OL http://www.cairographics.org/releases/pixman-0.30.0.tar.gz -o pixman.tar.gz
# tar -zxf pixman-0.30.0.tar.gz && cd pixman-0.30.0/
#
# curl -OL http://www.cairographics.org/releases/cairo-1.12.18.tar.xz
# tar -xf cairo-1.12.18.tar.xz && cd cairo-1.12.18
