from fastapi import FastAPI
from pydantic import BaseModel, Field

from ai.logic import AI_PIPELINE

app = FastAPI(title="TimeMem AI", docs_url=None, redoc_url=None)


class AnalyzeRequest(BaseModel):
    text: str = Field(min_length=1, max_length=4000)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "module": "ai"}


@app.post("/analyze")
def analyze(request: AnalyzeRequest) -> dict:
    return AI_PIPELINE.invoke({"text": request.text})
