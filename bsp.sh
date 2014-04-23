#!/bin/bash
#-----
#Better Scanpackages by jk9357 v0.1
#-----

#-----
#Configuration: (I'm anticipating having more stuff here)

#Path to folder that contains the deb files:
FILES="debs/*"

#Thanks.
#-----

#Delete Packages if it exists
if [ -a "Packages" ] ; then
	rm Packages
fi

#Make a new one
touch Packages

for f in $FILES
do
	echo "Processing: $f"
	#Extract control file from deb
	dpkg-deb --control $f
	#Remove newline at the end
	sed '${/^$/d;}' DEBIAN/control > control-
	sed '${/^$/d;}' control- >> Packages
	rm control-
	#Add Filename, MD5sum, SHA1 and SHA256
	echo "Filename: $f" >> Packages
	size=$(stat -c%s "$f")
	echo "Size: $size" >> Packages
	md5=$(md5sum $f | sed 's/ .*//')
	echo "MD5sum: $md5" >>Packages
	sha1=$(openssl sha1 $f | sed 's/^.*)= //')
	echo "SHA1: $sha1" >>Packages
	sha256=$(openssl sha256 $f | sed 's/^.*)= //')
	echo "SHA256: $sha256" >> Packages
	echo "" >> Packages
	#Clean Up
	rm -rf DEBIAN
done

#Package it
bzip2 Packages

#Thanks.
exit 0
