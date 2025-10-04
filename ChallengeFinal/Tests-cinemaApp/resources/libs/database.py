from robot.api.deco import keyword
from pymongo import MongoClient
import bcrypt

# --- ATENÇÃO: Substitua pela connection string do seu banco de dados do Cinema App ---
client = MongoClient('mongodb+srv://mario:12345@cluster0.hmqbxwo.mongodb.net/cinema-app?retryWrites=true&w=majority&appName=Cluster0')
db = client['cinema-app']


@keyword('Clean Cinema User')
def clean_cinema_user(user_email):
    """
    Remove um usuário e todas as suas reservas associadas do banco de dados.
    """
    users_collection = db['users']
    reservations_collection = db['reservations']

    user = users_collection.find_one({'email': user_email})

    if user:
        # Deleta as reservas feitas por este usuário
        reservations_collection.delete_many({'user': user['_id']})
        # Deleta o usuário
        users_collection.delete_one({'email': user_email})
        print(f"Usuário e reservas de '{user_email}' foram removidos.")

@keyword('Insert Cinema User')
def insert_cinema_user(user_data):
    """
    Insere um novo usuário no banco de dados com a senha hasheada.
    """
    users_collection = db['users']

    # O backend usa bcryptjs, que é compatível com a implementação do bcrypt em Python.
    password_bytes = user_data['password'].encode('utf-8')
    hashed_password = bcrypt.hashpw(password_bytes, bcrypt.gensalt())

    doc = {
        'name': user_data['name'],
        'email': user_data['email'],
        'password': hashed_password,
        'role': user_data.get('role', 'user') # Adiciona role, com 'user' como padrão
    }

    users_collection.insert_one(doc)
    print(f"Usuário '{user_data['email']}' inserido no banco.")

@keyword('Get User ID By Email')
def get_user_id_by_email(user_email):
    """
    Busca um usuário pelo e-mail e retorna seu _id como string.
    """
    users_collection = db['users']
    user = users_collection.find_one({'email': user_email})
    if user:
        return str(user['_id'])
    return None