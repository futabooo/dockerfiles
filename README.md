wordpressの環境をdockerで作るのが目標です

## start wordpress on docker
```bash
$ git clone https://github.com/futabooo/dockerfiles.git
$ cd path/to/dockerfiles
$ sudo docker build -t centos:wordpress .
$ sudo docker run -p 49174:80 -d centos:wordpress
```
`49174:80`はコンテナ側の49174ポートをホスト側の80ポートとつないでるだけなので、任意の値で。
