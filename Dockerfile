FROM node:alpine

RUN addgroup -S pimatic && adduser -G pimatic -S -D pimatic && mkdir /home/pimatic/pimatic-app && \
    apk update && apk add --no-cache python build-base tzdata && \
    cd home/pimatic && npm install pimatic --prefix pimatic-app --production && \
    cat /home/pimatic/pimatic-app/node_modules/pimatic/config_default.json | sed 's/"password": "",/"password": "admin",/' > /home/pimatic/pimatic-app/config.json && \
    cd /home/pimatic/pimatic-app && npm install sqlite3 && \
    cd /home/pimatic/pimatic-app/node_modules && \
    npm install pimatic-cron pimatic-mobile-frontend pimatic-iframe pimatic-shell-execute pimatic-sunrise pimatic-sysinfo pimatic-ping@0.9.5 && \
    cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && echo "Europe/Amsterdam" > /etc/timezone && apk del tzdata

CMD ["/bin/sh" "-c" "cd /home/pimatic/pimatic-app && ./node_modules/pimatic/pimatic.js"]

EXPOSE 80
