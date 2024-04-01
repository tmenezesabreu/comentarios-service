export VERSAO=$1
sudo docker build --no-cache -t tmenezesabreu/comentarios-service:$VERSAO .
sudo docker push tmenezesabreu/comentarios-service:$VERSAO
