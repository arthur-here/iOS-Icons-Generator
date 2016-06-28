#! /bin/bash
set -e

source_image=$1
iconset_name=$2

array=(
    "29 Icon-Small.png"
    "58 Icon-Small@2x.png"
    "87 Icon-Small@3x.png"
    "40 Icon-40.png"
    "80 Icon-40@2x.png"
    "120 Icon-40@3x.png"
    "120 Icon-60@2x.png"
    "180 Icon-60@3x.png"
    "76 Icon-76.png"
    "152 Icon-76@2x.png"
    "167 Icon-83.5@2x.png"
)

if [ -z "$source_image" ]
then
    echo "Error: You should provide image"
    exit 1
fi

source_image_width=`sips -g pixelWidth "$source_image"`
if [ ${source_image_width##*pixelWidth: } -ne 1024 ]
then
    echo "Error: Image size should be 1024x1024"
    exit 1
fi

source_image_height=`sips -g pixelHeight "$source_image"`
if [ ${source_image_height##*pixelHeight: } -ne 1024 ]
then
    echo "Error: Image size should be 1024x1024"
    exit 1
fi

if [ ! -f "Contents.json" ]
then
    echo "Error: File Contents.json not found"
    exit 1
fi

if [ -z "$iconset_name" ]
then
    iconset_name="AppIcon"
fi

if [ -d "$iconset_name.appiconset" ]
then
    echo "Error: Iconset with name $iconset_name already exists"
    exit 1
fi

mkdir "$iconset_name.appiconset"

for item in "${array[@]}"
do
    item_array=($item)
    size=${item_array[0]}
    image_name=${item_array[1]}
    sips -z "$size" "$size" "$source_image" --out "$iconset_name.appiconset/$image_name"
done

cp "Contents.json" "$iconset_name.appiconset/Contents.json"
