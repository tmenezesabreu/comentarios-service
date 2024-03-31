#!/bin/bash
# Faz a carga dos comentários para teste
curl -sv http://comentarios-service-api.68eae016.nip.io/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"first post!","content_id":1}'
curl -sv http://comentarios-service-api.68eae016.nip.io/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"ok, now I am gonna say something more useful","content_id":1}'
curl -sv http://comentarios-service-api.68eae016.nip.io/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I agree","content_id":1}'

# matéria 2
curl -sv http://comentarios-service-api.68eae016.nip.io/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I guess this is a good thing","content_id":2}'
curl -sv http://comentarios-service-api.68eae016.nip.io/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"charlie@example.com","comment":"Indeed, dear Bob, I believe so as well","content_id":2}'
curl -sv http://comentarios-service-api.68eae016.nip.io/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"eve@example.com","comment":"Nah, you both are wrong","content_id":2}'

# listagem matéria 1
curl -sv http://comentarios-service-api.68eae016.nip.io/api/comment/list/1

# listagem matéria 2
curl -sv http://comentarios-service-api.68eae016.nip.io/api/comment/list/2