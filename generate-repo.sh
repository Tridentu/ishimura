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

echo "📤 [Ishimura] Committing updates and routing to GitHub Pages..."
git add .
git commit -m "Migrated Ishimura repository metadata compression to XZ"
git push origin main
