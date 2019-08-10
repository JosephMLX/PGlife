# Import Flask and request module from Flask
from flask import Flask, request
from rivescript import RiveScript
# Import request
import requests
import json

# create a Flask app instance
app = Flask(__name__)

# bot settings
bot = RiveScript()
bot.load_directory("./brain")
bot.sort_replies()

# Tokens from the Facebook page web hooks
ACCESS_TOKEN = "EAAIJMvZBDPNEBAJT2zqhh03jrVUVRZAZAOINsmZC0jCce9NbhkTohkXX2ASZAfqhY9WZAzW2kScfVYCAZAn5vRYEEI9E7MyVznJY41YUohLDZCjFyYPFEqGZBhB4YN3unmXhl7ud1BHy4zPXFiG0WkjSgJwXQaiY7Ff83agQLoVadBQZDZD"
VERIFY_TOKEN = "mlx"

# method to reply to a message from the sender
def reply(user_id, msg):
    data = {
        "recipient": {"id": user_id},
        "message": {"text": msg}
    }
    # Post request using the Facebook Graph API v2.6
    resp = requests.post("https://graph.facebook.com/v2.6/me/messages?access_token=" + ACCESS_TOKEN, json=data)
    print(resp.content)

# GET request to handle the verification of tokens
@app.route('/', methods=['GET'])
def handle_verification():
    if request.args['hub.verify_token'] == VERIFY_TOKEN:
        return request.args['hub.challenge']
    else:
        return "Invalid verification token"

# POST request to handle in coming messages then call reply()
@app.route('/', methods=['POST'])
def handle_incoming_messages():
    data = request.json
    sender = data['entry'][0]['messaging'][0]['sender']['id']
    message = data['entry'][0]['messaging'][0]['message']['text']
    print(message)
    re = bot.reply("localuser", message)
    reply(sender, re)

    return "ok"


# Run the application.
if __name__ == '__main__':
    app.run(debug=True)
