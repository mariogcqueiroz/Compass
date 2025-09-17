from robot.api.deco import keyword
from pymongo import MongoClient

client = MongoClient('mongodb+srv://qa:xperience@cluster0.htf13qo.mongodb.net/markdb?retryWrites=true&w=majority&appName=Cluster0')
db = client['markdb']

@keyword('Remove user from database')
def remove_user(email):
    users = db['users']
    users.delete_many({'email': email})
    print('removing user by ' + email)

@keyword('Insert user from database')
def insert_user(name, email, password):
    doc = {
        'name': name,
        'email': email,
        'password': password
    }
    users = db['users']
    users.insert_one(doc)
    print(doc)
