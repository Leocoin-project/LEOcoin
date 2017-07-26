#!/bin/bash
shopt -s extglob
rm -rf build
mkdir -p build
cp -rp !(build) build/
sed -i 's^"assets^"qrc:///assets^g' build/index.html
# minify build/index.html > build/index.min.html
# mv build/index.min.html build/index.html
> build/LEOcoin.qrc
IFS=$'\n'
MINIFY="
assets/plugins/framework/framework.js
assets/plugins/boostrapv3/js/bootstrap.js
assets/plugins/boostrapv3/css/bootstrap.css
assets/plugins/jquery-scrollbar/jquery.scrollbar.js
assets/plugins/markdown/markdown.js
assets/css/font-awesome-buttons.css
assets/css/framework-icons.css
assets/css/framework.css
assets/css/styles.css
assets/css/custom.css
assets/js/navigation.js
assets/js/pages/send.js
assets/js/qrcode.js
assets/js/custom.js
assets/js/tooltip.js
assets/js/LEOcoin.js
"

for file in $MINIFY
do
    echo minify $file
    filename=${file%.*}
    extension=${file##*.}

    minify "$file" > build/$filename.min.$extension
    rm build/$file
    sed -i 's^'$file'^'$filename.min.$extension'^' build/index.html
done

cd build
assets=`find assets/ -type f|sort`
cd ..

while read line
do
    echo "$line" >> build/LEOcoin.qrc
    if [ "$line" == '    <qresource prefix="/">' ]
    then
        for asset in $assets
        do
            [[ $MINIFY =~ $asset ]] && continue
            echo '        <file alias="'$asset'">src/qt/res/'$asset'</file>' >> build/LEOcoin.qrc
        done
    fi
done < LEOcoin.qrc

ALIASES=()
FILES=()
unset IFS
while read line
do
    [ "$line" == '<qresource prefix="/">' ] && RES=true
    [ "$line" == '</qresource>' ] && break
    if [ "$RES" = true ]
    then
        line=`echo $line | sed 's^<file alias="\(.*\)">.*</file>^\1^'`
        ALIASES+=(${line})
        FILES+=("build/${line}")
    fi
done < build/LEOcoin.qrc

for index in ${!FILES[*]}
do
    file=${FILES[$index]}
    alias=${ALIASES[$index]}
    if [[ $file == *".css" ]] && [ $(fgrep "url(" $file -l) ]
    then
        DIR=`dirname $alias`
        PREVDIR=`dirname $DIR`
        REPLACE=$(fgrep "url(" $file | grep -o 'url(['\''"]\?\([^'\''")]\+\)["'\'']\?)' | sed 's/url(\|["'\'']\|)//g'|sed 's/&/\\&/g')
        for filename in $REPLACE
        do
            [[ $filename == "qrc:"* ]] && continue

            if [[ $filename == "../"* ]]
            then
              replacement=`echo $filename|sed 's!^..!qrc:///'$PREVDIR'!'`
              sed -i 's^url(['\''"]\?'$filename'['\''"]\?)^url('$replacement')^g' $file
            else
              replacement="qrc:///$DIR/$filename"
              sed -i 's^url(['\''"]\?'$filename'['\''"]\?)^url('$replacement')^g' $file
              #sed -i '
            fi
        done
        echo $file
    fi

    if [[ $file == *".js" ]] && [ $(fgrep "assets" $file -l) ]
    then
        sed -i 's^\(assets/\(js\|icons\|img\|plugins\)\)^qrc:///\1^g' $file
        sed -i 's^\./qrc:///^qrc:///^g' $file

        echo $file
    fi
done
