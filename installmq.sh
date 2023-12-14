#!/bin/bash

wget https://mtcad-my.sharepoint.com.mcas.ms/personal/balvinder_singh1_loblaw_ca/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fbalvinder%5Fsingh1%5Floblaw%5Fca%2FDocuments%2FSoftware%2F9%2E3%2E0%2E0%2DIBM%2DMQTRIAL%2DLinuxX64%2Etar%2Egz&McasTsid=15600

# Navigate to temporary directory
echo "In /tmp"
cd /tmp

# Enable error handling
set -e

# Variables
MQ_TAR_FILE="9.3.4.0-IBM-MQ-Advanced-for-Developers-UbuntuLinuxX64.tar"

# Display IBM files
echo "Listing IBM files:"
ls -lart | grep IBM
echo "Results listed."

# Decompress the TAR file
gunzip "$MQ_TAR_FILE"
echo "File Unzipped"

# Extract files from the TAR archive
tar -xvf "${MQ_TAR_FILE%.gz}"
echo "File Untarred" 

# Create directory for MQ installation
mkdir /opt/mqm
echo "Directory mqm created"


# Set permissions for the mqm directory
chmod 775 /opt/mqm

# Navigate to the MQServer directory
cd MQServer

# Run the mqlicense.sh script
./mqlicense.sh
echo "License accepted"

# Manually specify the RPM files
rpm_files=(
    "MQSeriesRuntime-9.2.0-5.x86_64.rpm"
    "MQSeriesSDK-9.2.0-5.x86_64.rpm"
    "MQSeriesSamples-9.2.0-5.x86_64.rpm"
    "MQSeriesGSKit-9.2.0-5.x86_64.rpm"
    "MQSeriesClient-9.2.0-5.x86_64.rpm"
    "MQSeriesMan-9.2.0-5.x86_64.rpm"
    "MQSeriesMsg_es-9.2.0-5.x86_64.rpm"
    "MQSeriesJava-9.2.0-5.x86_64.rpm"
    "MQSeriesServer-9.2.0-5.x86_64.rpm"
    "MQSeriesJRE-9.2.0-5.x86_64.rpm"
    "MQSeriesExplorer-9.2.0-5.x86_64.rpm"
    "MQSeriesWeb-9.2.0-5.x86_64.rpm"
)

# Iterate over the array and install each RPM file
for rpm_file in "${rpm_files[@]}"; do
    echo "Installing $rpm_file"
    rpm -ivh "$rpm_file"
done

# Return to the mqm/bin directory for post installation steps
cd "/opt/mqm/bin"

# Set the MQ environment
source setmqenv -s -k

# Check if MQ is installed successfully
if dspmqver; then
  echo "IBM MQ is installed successfully."
else
  echo "IBM MQ installation failed."
fi
