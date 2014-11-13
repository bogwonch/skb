FROM honeynet/androguard:latest
MAINTAINER Joseph Hallett <josephhallett@gmail.com>

WORKDIR /

# Install mallodroid
RUN git clone https://github.com/sfahl/mallodroid.git /usr/local/mallodroid
RUN ln -s /usr/local/mallodroid/mallodroid.py /usr/local/bin
RUN chmod -R 0555 /usr/local/mallodroid

# Add a mallodroid user
RUN useradd -ms /bin/false mallodroid
USER mallodroid

