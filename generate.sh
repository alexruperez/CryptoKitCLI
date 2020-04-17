remote_url=$(git remote get-url origin)
repo_name=$(basename -s .git $remote_url)
repo_path=$(dirname $remote_url)
author_handle=${repo_path##*:}
author_handle=${author_handle##*/}
executable_name=$(echo $repo_name | perl -pe 's/(^|-|_| |%20)(\w)/uc($2)/ge' )
author_name=$(git config user.name)
author_email=$(git config user.email)

for path in $(find . -type d -path "*EXECUTABLE-NAME*")
do
  mv $path ${path//EXECUTABLE-NAME/$executable_name}
done

for path in $(find . -type f ! -path "./.*/*" ! -name "./generate.sh" ! -name ".DS_Store")
do
  sed -i "" -e "s/AUTHOR-HANDLE/$author_handle/g" $path
  sed -i "" -e "s/AUTHOR-NAME/$author_name/g" $path
  sed -i "" -e "s/AUTHOR-EMAIL/$author_email/g" $path
  sed -i "" -e "s/EXECUTABLE-NAME/$executable_name/g" $path
  if [[ $path =~ "EXECUTABLE-NAME" ]]
  then
    mv $path ${path//EXECUTABLE-NAME/$executable_name}
  fi
done

swift test
swift run
open Package.swift

rm -rf ./generate.sh
