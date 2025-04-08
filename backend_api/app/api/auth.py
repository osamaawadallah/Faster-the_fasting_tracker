from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session
from app.schemas.user import UserCreate, UserLogin
from app.services.auth import create_user, authenticate_user, create_token
from app.core.database import get_session

router = APIRouter()

@router.post("/auth/register")
def register(data: UserCreate, session: Session = Depends(get_session)):
    print("REGISTER DATA RECEIVED:", data)
    try:
        user = create_user(session, data)
        token = create_token(user.id)
        return {"access_token": token}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/auth/login")
def login(data: UserLogin, session: Session = Depends(get_session)):
    print("LOGIN DATA RECEIVED:", data)
    user = authenticate_user(session, data.email, data.password)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = create_token(user.id)
    return {"access_token": token}
