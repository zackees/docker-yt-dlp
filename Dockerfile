# Use the official Python 3.10 Alpine-based image
FROM python:3.10-alpine



# Install yt-dlp dependencies and yt-dlp itself
# Adding build dependencies for packages that may require compilation
# and then removing unnecessary packages and cache
RUN apk add --no-cache --virtual .build-deps \
    ffmpeg \
    && pip install --no-cache-dir yt-dlp \
    # Removing build dependencies to reduce image size
    && apk del .build-deps

COPY entrypoint.sh entrypoint.sh

# Set the working directory in the container
WORKDIR /host_dir

RUN chmod +x /entrypoint.sh



# ENTRYPOINT ["/bin/bash", "-c", "/host_dir \"$@\"", "--"]

# Set the entrypoint to yt-dlp
# ENTRYPOINT ["sh", "-c", "yt-dlp \"$@\""]
# ENTRYPOINT ["sh", "-c", "/app/entrypoint"]
# CMD ["python", "-m", "http.server", "80"]
#CMD echo $var1
ENTRYPOINT ["/entrypoint.sh"]
