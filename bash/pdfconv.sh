PDF=$1
echo "Processing $PDF"
DIR=`basename "$1" .pdf`

mkdir "$DIR"

echo '  Splitting PDF file to pages...'
pdftk "$PDF" burst output "$DIR"/%04d.pdf
pdftk "$PDF" dump_data output "$DIR"/metadata.txt

echo '  Converting pages to PNG files...'
for i in "$DIR"/*.pdf; do
  convert -colorspace RGB -interlace none -density 100x100 -quality 100 "$i" "$DIR"/`basename "$i" .pdf`.png
done