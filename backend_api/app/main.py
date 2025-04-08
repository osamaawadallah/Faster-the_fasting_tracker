from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import auth, fasting
from app.core.database import engine
from app.models import user, fasting as fasting_model
from sqlmodel import SQLModel
from app.api import goals


app = FastAPI()

# ✅ CORS fix
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
def on_startup():
    SQLModel.metadata.create_all(engine)

app.include_router(auth.router)
app.include_router(fasting.router)
app.include_router(goals.router, prefix="/api")
