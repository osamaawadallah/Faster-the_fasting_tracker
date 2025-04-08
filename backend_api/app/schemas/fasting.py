from pydantic import BaseModel
from datetime import date

class FastingCreate(BaseModel):
    date: date
    type: str
    purpose: str = None
    note: str = None

class FastingOut(BaseModel):
    date: date
    type: str
    purpose: str