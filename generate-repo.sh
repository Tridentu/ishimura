#!/bin/bash
set -e

echo "🚢 [Ishimura] Purging stale metadata caches..."
find dists/ -name "Packages*" -delete
find dists/ -name "Release*" -delete

echo "🛠️ [Ishimura] Scanning directories and compiling XZ index files..."
# This will now automatically generate Packages and Packages.xz
apt-ftparchive generate apt-generate.conf

echo "🔖 [Ishimura] Binding master Release catalog variables..."
apt-ftparchive -c apt-generate.conf release dists/stable/ > dists/stable/Release

echo "Signing the master repository release structures..."
cd dists/stable/

# 1. Clear out any old signatures to avoid mismatch collisions
rm -f Release.gpg InRelease

# 2. Generate a detached signature (Release.gpg)
gpg --batch --yes --detach-sign --armor --output Release.gpg Release

# 3. Generate an inline unified signature (InRelease)
gpg --batch --yes --clearsign --armor --output InRelease Release

cd ../../
echo "Repository successfully updated and signed!"


echo "📤 [Ishimura] Committing updates and routing to GitHub Pages..."
git add .
git commit -m "Migrated Ishimura repository metadata compression to XZ"
git push origin main
