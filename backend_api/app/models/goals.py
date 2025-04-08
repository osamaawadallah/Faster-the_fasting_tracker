from sqlmodel import SQLModel, Field
from typing import Optional
from datetime import date, datetime

class FastingGoal(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    label: str
    type: str  # "obligatory" or "voluntary"
    start_date: date
    end_date: date
    target_count: int
    note: Optional[str] = None  # optional explanation or reminder
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
