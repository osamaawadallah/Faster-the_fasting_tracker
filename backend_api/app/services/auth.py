from app.models.user import User
from app.schemas.user import UserCreate
from sqlmodel import Session, select
from passlib.hash import bcrypt
from jose import jwt
from datetime import timedelta, datetime
from app.core.config import settings

def create_user(session: Session, data: UserCreate):
    user = session.exec(select(User).where(User.email == data.email)).first()
    if user:
        raise ValueError("Email already registered")
    hashed = bcrypt.hash(data.password)
    new_user = User(email=data.email, hashed_password=hashed)
    session.add(new_user)
    session.commit()
    session.refresh(new_user)
    return new_user

def authenticate_user(session: Session, email: str, password: str):
    user = session.exec(select(User).where(User.email == email)).first()
    if not user or not bcrypt.verify(password, user.hashed_password):
        return None
    return user

def create_token(user_id: int):
    payload = {
        "sub": str(user_id),
        "exp": datetime.utcnow() + timedelta(days=30),
    }
    return jwt.encode(payload, settings.JWT_SECRET, algorithm="HS256")
