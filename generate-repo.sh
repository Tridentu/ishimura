#!/bin/bash
set -e

echo "Cleaning up old index files..."
find dists/ -name "Packages*" -delete
find dists/ -name "Release*" -delete

echo "Generating modular Packages and Packages.gz indexes..."
apt-ftparchive generate apt-generate.conf

echo "Generating master Release index..."
apt-ftparchive -c apt-generate.conf release dists/stable/ > dists/stable/Release

echo "Ishimura indexing complete!"
