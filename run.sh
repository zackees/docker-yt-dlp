#docker run -d \
#    --name youtube-dl \
#    -v youtube-dl_data:/config \
#    -v downloads:/downloads \
#    jeeaaasustest/youtube-dl --version

#docker run --rm tnk4on/yt-dlp https://www.youtube.com/watch?v=DQVPS2d_n1Y --update


#docker run --rm --user root tnk4on/yt-dlp https://www.youtube.com/watch?v=DQVPS2d_n1Y --update

#docker run --rm --user root tnk4on/yt-dlp --update

docker run --rm --user root -v media:/media:Z tnk4on/yt-dlp https://www.youtube.com/watch?v=DQVPS2d_n1Y --update

#podman run --rm --user root -v media:/media:Z tnk4on/yt-dlp https://www.youtube.com/watch?v=DQVPS2d_n1Y --update
