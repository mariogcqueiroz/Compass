from robot.api.deco import keyword
from pymongo import MongoClient
import bcrypt


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

    password_bytes = user_data['password'].encode('utf-8')
    hashed_password = bcrypt.hashpw(password_bytes, bcrypt.gensalt())

    doc = {
        'name': user_data['name'],
        'email': user_data['email'],
        'password': hashed_password,
        'role': user_data.get('role', 'user') 
    }

    users_collection.insert_one(doc)
    print(f"Usuário '{user_data['email']}' inserido no banco.")

@keyword('Remove Cinema User')
def remove_cinema_user(user_data):
    """
    remove novo usuário no banco de dados.
    """
    users= db['users']
    email = user_data['email']
    users.delete_many({'email': email})
    print('removing user by ' + email)

@keyword('Clean Theater By Name')
def clean_theater_by_name(theater_name):
    """
    Remove um cinema pelo nome e todas as sessoes associadas a ele.
    """
    theaters_collection = db['theaters']
    sessions_collection = db['sessions']

    # Encontra o cinema pelo nome para obter seu ID
    theater = theaters_collection.find_one({'name': theater_name})

    if theater:
        theater_id = theater['_id']
        # 1. Deleta todas as sessoes que usam este cinema
        deleted_sessions = sessions_collection.delete_many({'theater': theater_id})
        print(f"{deleted_sessions.deleted_count} sessoes associadas ao cinema '{theater_name}' foram removidas.")
        
        # 2. Deleta o próprio cinema
        theaters_collection.delete_one({'name': theater_name})
        print(f"Cinema '{theater_name}' foi removido.")
        
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