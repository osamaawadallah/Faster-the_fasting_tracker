# app/api/goals.py
from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select
from app.core.database import get_session
from app.models.goals import FastingGoal
from app.schemas.goals import GoalCreate, GoalRead
from app.core.auth_dep import get_current_user

router = APIRouter()

@router.get("/goals", response_model=list[GoalRead])
def get_goals(user=Depends(get_current_user), session: Session = Depends(get_session)):
    result =  session.exec(select(FastingGoal).where(FastingGoal.user_id == user.id)).all()
    return result or []

@router.post("/goals", response_model=GoalRead)
def create_goal(goal: GoalCreate, user=Depends(get_current_user), session: Session = Depends(get_session)):
    db_goal = FastingGoal(user_id=user.id, **goal.dict())
    session.add(db_goal)
    session.commit()
    session.refresh(db_goal)
    return db_goal

@router.put("/goals/{goal_id}", response_model=GoalRead)
def update_goal(goal_id: int, goal: GoalCreate, user=Depends(get_current_user), session: Session = Depends(get_session)):
    existing = session.get(FastingGoal, goal_id)
    if not existing or existing.user_id != user.id:
        raise HTTPException(status_code=404, detail="Goal not found")
    for field, value in goal.dict().items():
        setattr(existing, field, value)
    session.add(existing)
    session.commit()
    session.refresh(existing)
    return existing
