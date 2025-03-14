FROM wordpress:latest

# Install required packages: wget and unzip
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Download and install the WP Offload Media plugin
RUN wget -O /tmp/amazon-s3-and-cloudfront.zip https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.3.2.8.zip \
    && unzip /tmp/amazon-s3-and-cloudfront.zip -d /var/www/html/wp-content/plugins/ \
    && rm /tmp/amazon-s3-and-cloudfront.zip
