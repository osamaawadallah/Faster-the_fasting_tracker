from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select
from app.core.database import get_session
from app.schemas.fasting import FastingCreate
from app.models.fasting import FastingDay
from app.core.auth_dep import get_current_user
from datetime import date as dt_date, datetime

router = APIRouter()

@router.post("/fasting")
def add_fasting_day(data: FastingCreate, user=Depends(get_current_user), session: Session = Depends(get_session)):
    if data.date > dt_date.today():
        raise HTTPException(status_code=400, detail="Cannot log future fasting days.")
    
    entry = FastingDay(user_id=user.id, **data.dict())
    session.add(entry)
    session.commit()
    return {"ok": True}

@router.delete("/fasting/{date_str}", status_code=204)
def remove_fasting_day(
    date_str: str,
    user=Depends(get_current_user),
    session: Session = Depends(get_session),
):
    try:
        parsed_date = datetime.fromisoformat(date_str).date()
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD.")

    stmt = select(FastingDay).where(
        FastingDay.user_id == user.id,
        FastingDay.date == parsed_date
    )
    result = session.exec(stmt).first()
    
    if not result:
        raise HTTPException(status_code=404, detail="Fasting day not found.")

    session.delete(result)
    session.commit()
    
@router.get("/fasting")
def list_fasting_days(user=Depends(get_current_user), session: Session = Depends(get_session)):
    return session.exec(select(FastingDay).where(FastingDay.user_id == user.id)).all()
