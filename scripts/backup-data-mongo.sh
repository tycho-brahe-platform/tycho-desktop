#!/bin/bash

container="$1"
database="$2"
corpus="$3"
folder="$4"
filename="$5"
mainCollection="$6"
mainQuery="$7"
relatedCollections="$8"
relatedQuery="$9"
extraFolder="${10}"
tempDir="${folder}temp/"

mkdir -p "${tempDir}${corpus}"

outputRegex="([0-9]*) record(s)?"

output=$(docker exec -t "${container}" mongoexport --db="${database}" --collection="${mainCollection}" --query="${mainQuery}" --out="${tempDir}${corpus}/${mainCollection}.json" --jsonArray)
if [[ $output =~ $outputRegex ]]
then
  echo "'${mainCollection}':${BASH_REMATCH[1]}"
else
  echo "${output}" 1>&2
  exit 64
fi

declare -a results=()
IFS=' ' read -r -a withFind <<< "${relatedCollections}"

for i in "${withFind[@]}"
do
  output=$(docker exec -t "${container}" mongoexport --db="${database}" --collection="${i}" --query="${relatedQuery}" --out="${tempDir}${corpus}/${i}.json" --jsonArray)
  if [[ $output =~ $outputRegex ]]
  then
    echo "'${i}':${BASH_REMATCH[1]}"
  else
    echo "${output}" 1>&2
    exit 64
  fi
done

cd "${tempDir}" || exit 1

# Check if extraFolder is provided
if [[ -n "${extraFolder}" ]]
then
  tar -zcvf "${filename}" "${corpus}" "${extraFolder}" > /dev/null 2>&1
else
  tar -zcvf "${filename}" "${corpus}" > /dev/null 2>&1
fi

rm -rf "${tempDir}${corpus}"/*