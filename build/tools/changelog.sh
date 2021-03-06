  
#!/bin/sh

export Changelog=Changelog.txt

DEVICE=$(echo $TARGET_PRODUCT | sed -e 's/lineage_//g')

if [ -f $Changelog ];
then
	rm -f $Changelog
fi

touch $Changelog

echo "Generating changelog..."

for i in $(seq 14);
do
export After_Date=`date --date="$i days ago" +%m-%d-%Y`
k=$(expr $i - 1)
	export Until_Date=`date --date="$k days ago" +%m-%d-%Y`

	# Line with after --- until was too long for a small ListView
	echo '=======================' >> $Changelog;
	echo  "     "$Until_Date       >> $Changelog;
	echo '=======================' >> $Changelog;
	echo >> $Changelog;

	# Cycle through every repo to find commits between 2 dates
	CURRENT_PATH="$(realpath `pwd`)"

    repo forall -c "GIT_LOG=\`git log --oneline --after=$After_Date --until=$Until_Date\` ; if [ ! -z \"\$GIT_LOG\" ]; then printf  '\n   * '; realpath \`pwd\` | sed 's|^$CURRENT_PATH/||' ; echo \"\$GIT_LOG\"; fi" >> $Changelog
	echo "" >> $Changelog;
done

sed -i 's/project/   */g' $Changelog

cp $Changelog $OUT_DIR/target/product/$DEVICE/system/etc/
cp $Changelog $OUT_DIR/target/product/$DEVICE