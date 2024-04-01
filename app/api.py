from flask import Flask
from flask import jsonify
from flask import request

import redis, json

import os, sys
senha_redis = os.environ.get('REDIS_PASSWORD')
if not senha_redis:
    print("Erro: a senha do REDIS não foi informada!")


redisRW = redis.Redis(host='redis-master.servicos.svc.cluster.local', port=6379, db=0, password=senha_redis, decode_responses=True)
redisRO = redis.Redis(host='redis-replicas.servicos.svc.cluster.local', port=6379, db=0, password=senha_redis, decode_responses=True)
# 4GgQsPDSVU

app_name = 'comentarios'
app = Flask(app_name)
app.debug = True

comments = {}


@app.route('/api/comment/new', methods=['POST'])
def api_comment_new():
    request_data = request.get_json()

    email = request_data['email']
    comment = request_data['comment']
    content_id = '{}'.format(request_data['content_id'])

    new_comment = {
            'email': email,
            'comment': comment,
            }

    ## Para escrita utilizar o redis master
    redisRW.rpush(content_id, json.dumps(new_comment))
    # if content_id in comments:
    #     comments[content_id].append(new_comment)
    # else:
    #     comments[content_id] = [new_comment]

    message = 'comment created and associated with content_id {}'.format(content_id)
    response = {
            'status': 'SUCCESS',
            'message': message,
            }
    return jsonify(response)


@app.route('/api/comment/list/<content_id>')
def api_comment_list(content_id):
    content_id = '{}'.format(content_id)

    # if content_id in comments:
    #     return jsonify(comments[content_id])
    # else:
    #     message = 'content_id {} not found'.format(content_id)
    #     response = {
    #             'status': 'NOT-FOUND',
    #             'message': message,
    #             }
    #     return jsonify(response), 404
    # Recupera todos os comentários associados ao content_id

    comments = redisRO.lrange(content_id, 0, -1)
    comments = [json.loads(comment) for comment in comments] if comments else []

    if comments:
        return jsonify(comments)
    else:
        message = 'content_id {} not found'.format(content_id)
        response = {
            'status': 'NOT-FOUND',
            'message': message,
        }
        return jsonify(response), 404


@app.route('/healthcheck', methods=['GET'])
def healthcheck():
       return jsonify({"status": "ok"}), 200

