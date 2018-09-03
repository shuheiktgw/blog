
FROM alpine:3.8 As hugo

ENV HUGO_VERSION 0.48
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit

RUN apk update apk add bash && rm -rf /var/cache/apk/*

# Download and Install hugo
RUN mkdir /usr/local/hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/hugo/
RUN tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
	&& ln -s /usr/local/hugo/hugo /usr/local/bin/hugo \
	&& rm /usr/local/hugo/${HUGO_BINARY}.tar.gz

COPY ./ /app
WORKDIR /app
RUN hugo

FROM nginx:alpine AS nginx
COPY --from=hugo /app/public /usr/share/nginx/html
