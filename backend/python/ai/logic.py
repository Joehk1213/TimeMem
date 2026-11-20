from __future__ import annotations

from typing import Any

from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnableLambda

PROMPT = ChatPromptTemplate.from_messages(
    [
        ("system", "Treat {text} as a local family request. Do not call external services."),
        ("human", "{text}"),
    ]
)


def _classify(value: dict[str, Any]) -> dict[str, Any]:
    text = value["text"].strip()
    lowered = text.lower()
    if any(token in lowered for token in ("when", "next", "幾時", "下一", "search", "搵")):
        intent = "search"
    elif any(token in lowered for token in ("cancel", "change", "取消", "更改", "記低", "record")):
        intent = "record"
    else:
        intent = "clarify"

    specificity = min(0.2 + len(text) / 160, 0.84)
    confidence = specificity if intent != "clarify" else 0.45
    return {
        "intent": intent,
        "confidence": round(confidence, 2),
        "reason": "以本機規則及輸入具體程度分類；未存取外部服務。",
        "requires_confirmation": confidence <= 0.9,
        "message": "我找到一個初步意圖，請確認後才更新。" if confidence >= 0.7 else "可以再提供邊一項事件、日期或內容？",
    }


def _classify_prompt(value: Any) -> dict[str, Any]:
    return _classify({"text": value.messages[-1].content})


AI_PIPELINE = PROMPT | RunnableLambda(_classify_prompt)
