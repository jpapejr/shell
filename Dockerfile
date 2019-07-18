FROM ubuntu:latest

########################
### Start customization
########################
RUN apt update && apt install -y zsh curl unzip wget  \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://ibm.biz/idt-installer | bash
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
RUN cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc
RUN git clone https://github.com/denysdovhan/spaceship-prompt.git "/root/.oh-my-zsh/custom/themes/spaceship-prompt"
RUN ln -s "/root/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "/root/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
RUN sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"spaceship\"/g" /root/.zshrc

ADD https://github.com/wercker/stern/releases/download/1.10.0/stern_linux_amd64 /usr/local/bin/stern
ADD https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 /usr/local/bin/jq
ADD https://github.com/sharkdp/bat/releases/download/v0.10.0/bat-musl_0.10.0_amd64.deb /root/bat.deb
ADD https://github.com/derailed/k9s/releases/download/0.6.5/k9s_0.6.5_Linux_x86_64.tar.gz /usr/local/bin/k9s.tgz
ADD https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip /usr/local/bin/ngrok.zip
ADD https://raw.githubusercontent.com/jpapejr/docker/master/ibmcloud/get-iks-configs.sh /usr/local/bin/get-iks-configs.sh
ADD https://raw.githubusercontent.com/helm/helm/master/scripts/completions.bash /root/helm.bash
RUN cd /usr/local/bin && unzip -d . ngrok.zip
RUN cd /usr/local/bin/ && tar xvfz /usr/local/bin/k9s.tgz && cd -

RUN dpkg -i /root/bat.deb \
    && chmod -R +x /usr/local/bin/* \ 
    && echo "autoload -Uz compinit" >> /root/.zshrc \
    && echo "compinit" >> /root/.zshrc \
    && echo "source <(kubectl completion zsh)" >> /root/.zshrc \
    &&  echo "source /usr/local/ibmcloud/autocomplete/zsh_autocomplete " >> /root/.zshrc \
    && mkdir -p /root/.kube

########################
### END customization
########################
