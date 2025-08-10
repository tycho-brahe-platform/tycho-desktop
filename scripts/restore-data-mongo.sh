#!/bin/bash

container="$1"
database="$2"
corpus="$3"
localDir="$4"
filename="$5"

inputDir="${localDir}input/"
tempDir="${inputDir}temp/"
filesDir="${localDir}files/"

# Create necessary folders if they do not exist
mkdir -p "$tempDir"
mkdir -p "$filesDir"

# Clean previous temp folder if exists
rm -R "${tempDir}${corpus}" 2>/dev/null

# Extract the tar file into the temp directory
tar -zxvf "${filename}" -C "${tempDir}"

# Import each JSON file into the MongoDB container
for file in "${tempDir}${corpus}"/*.json; do
	collection=$(basename "$file" .json)
	jsonFile="${localDir}input/temp/${corpus}${file##*/}"
	docker exec -t "${container}" mongoimport --db "${database}" --collection "$collection" --file "$jsonFile" --jsonArray --mode=upsert --upsertFields _id
done

# Clean up
rm -R "${tempDir}${corpus}"
mv "${filename}" "${filesDir}"
