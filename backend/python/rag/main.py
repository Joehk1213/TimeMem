from typing import Any

from fastapi import FastAPI
from pydantic import BaseModel, Field

from rag.retrieval import retrieve

app = FastAPI(title="TimeMem RAG", docs_url=None, redoc_url=None)


class Candidate(BaseModel):
    id: str
    text: str = Field(min_length=1, max_length=12000)
    metadata: dict[str, Any] = Field(default_factory=dict)


class SearchRequest(BaseModel):
    query: str = Field(min_length=1, max_length=4000)
    candidates: list[Candidate] = Field(max_length=500)
    limit: int = Field(default=5, ge=1, le=20)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "module": "rag"}


@app.post("/search")
def search(request: SearchRequest) -> dict:
    results = retrieve(request.query, [item.model_dump() for item in request.candidates], request.limit)
    return {
        "query": request.query,
        "results": results,
        "explanation": "只搜尋 Gateway 已授權提供的 context；RAG 不連接 PostgreSQL。",
    }
