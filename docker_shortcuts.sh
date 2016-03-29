alias gs='git status'
alias ga='git add'
alias gc='git commit'

alias gps='git push'
alias gpl='git pull'

dps()  {
  docker ps $@ | awk '
  NR==1{
    FIRSTLINEWIDTH=length($0)
    IDPOS=index($0,"CONTAINER ID");
    IMAGEPOS=index($0,"IMAGE");
    COMMANDPOS=index($0,"COMMAND");
    CREATEDPOS=index($0,"CREATED");
    STATUSPOS=index($0,"STATUS");
    PORTSPOS=index($0,"PORTS");
    NAMESPOS=index($0,"NAMES");
    UPDATECOL();
  }
  function UPDATECOL () {
    ID=substr($0,IDPOS,IMAGEPOS-IDPOS-1);
    IMAGE=substr($0,IMAGEPOS,COMMANDPOS-IMAGEPOS-1);
    COMMAND=substr($0,COMMANDPOS,CREATEDPOS-COMMANDPOS-1);
    CREATED=substr($0,CREATEDPOS,STATUSPOS-CREATEDPOS-1);
    STATUS=substr($0,STATUSPOS,PORTSPOS-STATUSPOS-1);
    PORTS=substr($0,PORTSPOS,NAMESPOS-PORTSPOS-1);
    NAMES=substr($0, NAMESPOS);
  }
  function PRINT () {
    print ID IMAGE STATUS CREATED COMMAND NAMES;
  }
  NR==2{
    NAMES=sprintf("%s%*s",NAMES,length($0)-FIRSTLINEWIDTH,"");
    PRINT();
  }
  NR>1{
    UPDATECOL();
    PRINT();
  }' | less -FSX;
}
dpsa() { dps -a $@; }

alias dl='docker logs --tail=50'
alias dlf='docker logs --tail=20 -f'
alias di='docker inspect'

reg="registry.esav.fi:5000"

dcent() { docker run --rm -ti $@ registry.esav.fi:5000/centos bash; }
dcentos() { docker run --rm -ti $@ registry.esav.fi:5000/centos bash; }

dcentv() { docker run --rm -ti --volumes-from $@ registry.esav.fi:5000/centos bash; }
dcentosv() { docker run --rm -ti --volumes-from $@ registry.esav.fi:5000/centos bash; }

dbash() { docker exec -ti $1 bash; }


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export PATH="$PATH:$DIR/bin"
