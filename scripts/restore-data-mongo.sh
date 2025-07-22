#!/bin/bash

container="$1"
database="$2"
corpus="$3"
localDir="$4"
filename="$5"

inputDir="${localDir}input/"
tempDir="${inputDir}temp/"
filesDir="${localDir}files/"

# Clean previous temp folder if exists
rm -R "${tempDir}${corpus}" 2>/dev/null

# Extract the tar file into the temp directory
tar -zxvf "${filename}" -C "${tempDir}"

for file in "${tempDir}${corpus}"/*.json; do
	collection=$(basename "$file" .json)
	docker exec -t ${container} mongoimport --db ${database} --collection "$collection" --file "$file" --jsonArray --mode=upsert --upsertFields _id
done

# Clean up
rm -R "${tempDir}/${corpus}"
mv "${filename}" "${filesDir}"
