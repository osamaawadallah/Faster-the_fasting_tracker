from sqlmodel import SQLModel, Field
from typing import Optional
from datetime import date, datetime

class FastingDay(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    date: date
    type: str  # "obligatory", "voluntary"
    purpose: Optional[str]  # e.g. "Ayyam Al-Beed", "Missed Ramadan"
    note: str = None