# Use the official Python 3.10 Alpine-based image
FROM python:3.10-alpine

# Install yt-dlp dependencies and yt-dlp itself
# Adding necessary packages including ffmpeg
RUN apk add --no-cache \
    ffmpeg \
    dos2unix \
    && pip install --no-cache-dir yt-dlp

# Set the working directory in the container
WORKDIR /host_dir

# Build the entrypoint script in the container.
RUN cat <<EOF > /entrypoint.sh
#!/bin/sh
yt-dlp "\$@"
EOF
RUN chmod +x /entrypoint.sh

# Set the entrypoint to use /bin/sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
