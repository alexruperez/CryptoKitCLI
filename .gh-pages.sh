git remote set-url origin git@github.com:alexruperez/CryptoKitCLI.git
git checkout -B gh-pages
gem install jazzy
./.docs.sh
find . -type f ! -path "./.git/*" ! -path "./docs*" ! -path "./LICENSE" -exec rm -f {} +
mv docs/* ./
touch .nojekyll
git add -f .
git commit -m "Documentation update."
git push -f origin gh-pages
