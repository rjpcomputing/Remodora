FROM alpine:latest

ARG user
ARG password

RUN apk add build-base luajit luarocks5.1 lua5.1-dev openssl-dev pianobar git

WORKDIR /opt/remodora

COPY . ./

RUN luarocks-5.1 install turbo
RUN luarocks-5.1 install luajson
RUN luarocks-5.1 install penlight
RUN luarocks-5.1 install luasocket

RUN mkdir --parents ~/.config/pianobar
RUN cp ./src/support/events.lua ~/.config/pianobar/events.lua
RUN sed -i "s|%s|/root/.config/pianobar|g" ~/.config/pianobar/events.lua
RUN chmod +x ~/.config/pianobar/events.lua
RUN mkfifo ~/.config/pianobar/ctl

# Write initial config
RUN echo "user = $user" >> ~/.config/pianobar/config
RUN echo "password = $password" >> ~/.config/pianobar/config
RUN echo "sort = quickmix_10_name_az" >> ~/.config/pianobar/config
RUN echo "audio_quality = high" >> ~/.config/pianobar/config
RUN echo "event_command = /root/.config/pianobar/events.lua" >> ~/.config/pianobar/config
RUN echo "fifo = /root/.config/pianobar/ctl" >> ~/.config/pianobar/config

CMD ./remodora
