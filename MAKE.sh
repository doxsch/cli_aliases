# /bin/bash
PROJECT_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$PROJECT_HOME/dist" ]; then rm -Rf  $PROJECT_HOME/dist; fi

cp -r $PROJECT_HOME/src $PROJECT_HOME/dist 
cd $PROJECT_HOME/dist
echo "==============================="
echo "creating composing alias files..."
echo "==============================="

find ./** -type d | while read folder_path; do
  echo "doing for folder $folder_path..."
  cd $PROJECT_HOME/dist/$folder_path
  filename="_$(basename $folder_path)_aliases"
  find . -type f ! -name '_*' -name '*_aliases' | while read file; do
    cat $file >> $filename
    echo "" >> $filename
  done
  echo " - $filename created."
  echo "---------------------------" 
done
echo ""
echo ""
echo "==============================="
echo "creating unalias files..."
echo "==============================="

cd $PROJECT_HOME/dist
find ./** -type d | while read folder_path; do
  echo "doing for folder $folder_path"
  cd $PROJECT_HOME/dist/$folder_path
  find . -type f -name '*_aliases'  -name '*_aliases' -maxdepth 1  | while read file; do
    unaliasFile=$(basename $file | sed 's/alias/unalias/g')
    sed 's/alias/unalias/g' $file | sed "s/='.*'//g" >> $unaliasFile

    echo '' >> $unaliasFile
    echo " - $unaliasFile created."

  done
    echo "---------------------------" 
 
done

cd $PROJECT_HOME/dist
echo "==============================="
echo "creating readme files..."
echo "==============================="

find ./** -type d | while read folder_path; do
  echo "doing for folder $folder_path..."
  cd $PROJECT_HOME/dist/$folder_path
  filename="$(basename $folder_path)"
  echo "# $filename" >> "README.md"
  echo 'files:'
  find . -type f -name "_$filename\_aliases" | while read file; do
    cat $file | 
    sed "s/\(alias.*\)/\`\`\`bash\n\1\n\`\`\`/" |
    sed "s/#/##/g" >> "README.md"
    echo "" >> "README.md"
    echo "" >> "README.md"
  done
  echo " - $filename.md created."
  echo "---------------------------" 
done
echo ""



cd $PROJECT_HOME/dist
echo "==============================="
echo "creating install.sh file..."
echo "==============================="

gh_base="https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/"

URLS=""
OPTIONS=""
FILES=($(find . -type f -name "*_aliases" ! -name "_*_*" 2>/dev/null))

for file in "${FILES[@]}"
do
  option="$(echo $file | sed "s|\.\/bash\/||")"
  OPTIONS+=" \"$option\"" 
  url="$(echo $file | sed "s|\.\/|$gh_base|")" 
  URLS+=" $url"
done

echo "---------------------"
echo $URLS
echo $OPTIONS


echo "options=($OPTIONS)">./bash/install.sh
echo "urls=($URLS)">>./bash/install.sh

cat $PROJECT_HOME/install.sh >> ./bash/install.sh