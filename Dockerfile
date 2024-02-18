# Use the official Python 3.10 Alpine-based image
FROM python:3.10-alpine

# Set the working directory in the container
WORKDIR /app

# Install yt-dlp dependencies and yt-dlp itself
# Adding build dependencies for packages that may require compilation
# and then removing unnecessary packages and cache
RUN apk add --no-cache --virtual .build-deps \
    ffmpeg \
    && pip install --no-cache-dir yt-dlp \
    # Removing build dependencies to reduce image size
    && apk del .build-deps


# Set the entrypoint to yt-dlp
ENTRYPOINT ["yt-dlp"]
