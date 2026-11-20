from __future__ import annotations

import hashlib
import math
from collections import Counter


def _vector(text: str) -> list[float]:
    counts = Counter(text.lower().split())
    dimensions = [0.0] * 64
    for token, count in counts.items():
        index = int.from_bytes(hashlib.sha256(token.encode()).digest()[:2], "big") % 64
        dimensions[index] += count
    magnitude = math.sqrt(sum(value * value for value in dimensions)) or 1.0
    return [value / magnitude for value in dimensions]


def similarity(left: str, right: str) -> float:
    left_vector, right_vector = _vector(left), _vector(right)
    return sum(a * b for a, b in zip(left_vector, right_vector, strict=True))


def retrieve(query: str, candidates: list[dict], limit: int) -> list[dict]:
    ranked = [
        {**candidate, "score": round(similarity(query, candidate["text"]), 4)}
        for candidate in candidates
    ]
    return sorted(ranked, key=lambda item: item["score"], reverse=True)[:limit]
