FROM postgres

RUN apt-get update
RUN apt-get -y install unzip ruby dos2unix curl

RUN mkdir /data
COPY install.sql /data/
COPY update_csvs.rb /data/
RUN cd /data && \
    curl -LO https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks-oltp-install-script.zip && \
    mv AdventureWorks-oltp-install-script.zip adventure_works_2014_OLTP_script.zip && \
    unzip adventure_works_2014_OLTP_script.zip && \
    rm adventure_works_2014_OLTP_script.zip && \
    ruby update_csvs.rb && \
    rm update_csvs.rb

COPY install.sh /docker-entrypoint-initdb.d/
RUN dos2unix /docker-entrypoint-initdb.d/*.sh