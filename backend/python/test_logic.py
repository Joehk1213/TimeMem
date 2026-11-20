import unittest

from ai.logic import AI_PIPELINE, _classify
from rag.retrieval import retrieve


class LogicTests(unittest.TestCase):
    def test_ai_search_intent_and_confirmation(self):
        result = _classify({"text": "下一堂滑板班幾時"})
        self.assertEqual(result["intent"], "search")
        self.assertTrue(result["requires_confirmation"])
        pipeline_result = AI_PIPELINE.invoke({"text": "下一堂滑板班幾時"})
        self.assertEqual(pipeline_result["intent"], "search")

    def test_rag_ranks_matching_context(self):
        result = retrieve(
            "skate class saturday",
            [
                {"id": "1", "text": "swimming class monday"},
                {"id": "2", "text": "skate class saturday"},
            ],
            2,
        )
        self.assertEqual(result[0]["id"], "2")


if __name__ == "__main__":
    unittest.main()
