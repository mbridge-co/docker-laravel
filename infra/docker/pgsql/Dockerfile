FROM postgres:8.4
#FROM postgres:14.8-alpine


# Time Zone
ENV TZ Asia/Tokyo

# Language
RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    locales \
    vim \
  && apt-get clean \
  && locale-gen ja_JP.eucJP \
  && localedef -f EUC_JP -i ja_JP.eucJP ja_JP.eucJP \

ENV LANG ja_JP.eucJP
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.eucJP

