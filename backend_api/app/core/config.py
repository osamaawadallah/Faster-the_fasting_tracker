from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    JWT_SECRET: str = "super-secret"
    DATABASE_URL: str = "postgresql://fasting:fasting123@db/fasting_app"

settings = Settings()
