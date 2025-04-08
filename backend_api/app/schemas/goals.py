from pydantic import BaseModel
from datetime import date

class GoalCreate(BaseModel):
    label: str
    target_count: int
    start_date: date
    end_date: date

class GoalRead(GoalCreate):
    id: int