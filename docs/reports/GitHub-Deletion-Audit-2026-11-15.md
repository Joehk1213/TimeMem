> 歷史文件：本文撰寫時現行版為 V10.1；現行版已為 V10.2。

# GitHub Deletion Audit - 2026-11-15

## Scope and status

> 更新（2026-11-15）：Joe 已指示本機移除 `.github` Skills 副本；已刪走 `.github` 嗰套 Skills，Sync 已停用，只用 `.agents/skills/`，Luna 為主要工具。本次僅本機 Commit，未 Push；下方分類是本次指示前的歷史 Audit。

- Scope: `C:\Project\TimeMem` working tree; Backup was confirmed present at `Desktop\TimeMem-BACKUP-2026-11-15` and used read-only. No Backup files were changed.
- Initial staged count: **0**. All 344 deletion-related entries are worktree deletions with status ` D`; there are no `AD` or `MD` entries.
- `git status --porcelain=v1`: **383 rows**; `git status --porcelain=v1 --untracked-files=all`: **736 rows**.
- Expanded status breakdown: **344 D**, **8 M**, **384 ??**. In the default view, untracked directories are collapsed into **31 ?? rows**.
- VS Code `743` and earlier Luna `386/749` are presentation/count snapshots, not directly interchangeable counts. Default status collapses untracked directories, while `--untracked-files=all` expands individual files. The current paired counts are 383/736; the historical 743 cannot be reproduced from this current snapshot, so none of those UI figures alone proves files suddenly appeared or disappeared.

## Classification summary

| Class | Count | Decision |
|---|---:|---|
| A - Relocated | 8 | Candidate move pairs; do not push deletion-only. |
| B - True deletion, reasonable | 0 | No evidence-backed disposable deletion found. |
| C - Do not push | 336 | Active Skills paths removed; cold copies exist but do not preserve active discovery. Hold for Joe review. |
| D - Unconfirmed | 0 | All items had sufficient path/Backup evidence for one of the other classes. |
| **Total** | **344** | **Do not push the complete deletion set now.** |

## Findings and next steps

- **A (8):** Six documentation moves are supported by exact repo/Backup SHA-256 equality. They may be reviewed as one documentation-move batch, pairing each old-path deletion with its new-path copy. Two `.jfif` files have same-name destinations under `reference/` in both repo and Backup; the images were not opened or hashed, so defer those two until Joe authorizes a visual/identity check.
- **C (336):** Each deleted `.agents/skills/...` or `.github/skills/...` path has a same-content counterpart under the corresponding `skills-cold/` path in both repo and Backup. Because this removes the original active-skill path, it is not treated as a harmless relocation. **Do not push these deletions** until Joe confirms the deactivation is intended and the cold copies receive any required content review.
- **B (0):** No deletion was both absent from the repo and backed by evidence that it was duplicate, temporary, or confirmed unwanted.
- **D (0):** No remaining item needs an unknown/assumed classification under the evidence gathered; image contents remain intentionally uninspected.
- Recommendation: do not push the current deletion set. Only the six documentation move pairs are candidates for a later batch after approval; hold the two image moves for identity confirmation; do not push the 336 active-Skills deletions.

## Evidence and protected-file checks

- `.gitignore` contains `/docs/evidence/**`; `docs/evidence/` had **0** entries in expanded Git status.
- SHA-256 baseline for six Gate documents, the evidence list, and v1/v2 summary files: **9/9 unchanged** at report creation. Their Git status entries are also compared before/after report creation.
- The two reference images were checked only by path existence/name; image bytes were not read or hashed. No evidence images or key files were opened.
- M0 remains **Draft / NOT APPROVED**. This audit is not approval; approval authority remains Joe.

## Complete deletion list

| # | Class | Status | Deleted path | Verified counterpart / disposition |
|---:|:---:|:---:|---|---|
| 1 | C | ` D` | `.agents/skills/agent-protocol/references/invocation-patterns.md` | Cold copy: `.agents/skills-cold/agent-protocol/references/invocation-patterns.md`; active-skill path removal is not approved. |
| 2 | C | ` D` | `.agents/skills/agent-protocol/SKILL.md` | Cold copy: `.agents/skills-cold/agent-protocol/SKILL.md`; active-skill path removal is not approved. |
| 3 | C | ` D` | `.agents/skills/agent-run-forensics/assets/claims_example.txt` | Cold copy: `.agents/skills-cold/agent-run-forensics/assets/claims_example.txt`; active-skill path removal is not approved. |
| 4 | C | ` D` | `.agents/skills/agent-run-forensics/assets/forensic_answer_template.md` | Cold copy: `.agents/skills-cold/agent-run-forensics/assets/forensic_answer_template.md`; active-skill path removal is not approved. |
| 5 | C | ` D` | `.agents/skills/agent-run-forensics/references/claim_verification.md` | Cold copy: `.agents/skills-cold/agent-run-forensics/references/claim_verification.md`; active-skill path removal is not approved. |
| 6 | C | ` D` | `.agents/skills/agent-run-forensics/references/recorded_vs_inferred.md` | Cold copy: `.agents/skills-cold/agent-run-forensics/references/recorded_vs_inferred.md`; active-skill path removal is not approved. |
| 7 | C | ` D` | `.agents/skills/agent-run-forensics/references/trace_sources.md` | Cold copy: `.agents/skills-cold/agent-run-forensics/references/trace_sources.md`; active-skill path removal is not approved. |
| 8 | C | ` D` | `.agents/skills/agent-run-forensics/scripts/claim_checker.py` | Cold copy: `.agents/skills-cold/agent-run-forensics/scripts/claim_checker.py`; active-skill path removal is not approved. |
| 9 | C | ` D` | `.agents/skills/agent-run-forensics/scripts/trace_core.py` | Cold copy: `.agents/skills-cold/agent-run-forensics/scripts/trace_core.py`; active-skill path removal is not approved. |
| 10 | C | ` D` | `.agents/skills/agent-run-forensics/scripts/trace_finder.py` | Cold copy: `.agents/skills-cold/agent-run-forensics/scripts/trace_finder.py`; active-skill path removal is not approved. |
| 11 | C | ` D` | `.agents/skills/agent-run-forensics/scripts/trace_timeline.py` | Cold copy: `.agents/skills-cold/agent-run-forensics/scripts/trace_timeline.py`; active-skill path removal is not approved. |
| 12 | C | ` D` | `.agents/skills/agent-run-forensics/SKILL.md` | Cold copy: `.agents/skills-cold/agent-run-forensics/SKILL.md`; active-skill path removal is not approved. |
| 13 | C | ` D` | `.agents/skills/agent-workflow-designer/references/workflow-patterns.md` | Cold copy: `.agents/skills-cold/agent-workflow-designer/references/workflow-patterns.md`; active-skill path removal is not approved. |
| 14 | C | ` D` | `.agents/skills/agent-workflow-designer/scripts/workflow_scaffolder.py` | Cold copy: `.agents/skills-cold/agent-workflow-designer/scripts/workflow_scaffolder.py`; active-skill path removal is not approved. |
| 15 | C | ` D` | `.agents/skills/agent-workflow-designer/SKILL.md` | Cold copy: `.agents/skills-cold/agent-workflow-designer/SKILL.md`; active-skill path removal is not approved. |
| 16 | C | ` D` | `.agents/skills/book-to-skill/assets/chapter_template.md` | Cold copy: `.agents/skills-cold/book-to-skill/assets/chapter_template.md`; active-skill path removal is not approved. |
| 17 | C | ` D` | `.agents/skills/book-to-skill/assets/cheatsheet_template.md` | Cold copy: `.agents/skills-cold/book-to-skill/assets/cheatsheet_template.md`; active-skill path removal is not approved. |
| 18 | C | ` D` | `.agents/skills/book-to-skill/assets/master_skill_template.md` | Cold copy: `.agents/skills-cold/book-to-skill/assets/master_skill_template.md`; active-skill path removal is not approved. |
| 19 | C | ` D` | `.agents/skills/book-to-skill/references/conversion_workflow.md` | Cold copy: `.agents/skills-cold/book-to-skill/references/conversion_workflow.md`; active-skill path removal is not approved. |
| 20 | C | ` D` | `.agents/skills/book-to-skill/references/document_extraction_pipeline.md` | Cold copy: `.agents/skills-cold/book-to-skill/references/document_extraction_pipeline.md`; active-skill path removal is not approved. |
| 21 | C | ` D` | `.agents/skills/book-to-skill/references/knowledge_extraction_canon.md` | Cold copy: `.agents/skills-cold/book-to-skill/references/knowledge_extraction_canon.md`; active-skill path removal is not approved. |
| 22 | C | ` D` | `.agents/skills/book-to-skill/references/progressive_disclosure_budgets.md` | Cold copy: `.agents/skills-cold/book-to-skill/references/progressive_disclosure_budgets.md`; active-skill path removal is not approved. |
| 23 | C | ` D` | `.agents/skills/book-to-skill/references/rights_and_provenance.md` | Cold copy: `.agents/skills-cold/book-to-skill/references/rights_and_provenance.md`; active-skill path removal is not approved. |
| 24 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_skill_validator.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_skill_validator.py`; active-skill path removal is not approved. |
| 25 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/__init__.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/__init__.py`; active-skill path removal is not approved. |
| 26 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/config.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/config.py`; active-skill path removal is not approved. |
| 27 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/dependencies.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/dependencies.py`; active-skill path removal is not approved. |
| 28 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/exceptions.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/exceptions.py`; active-skill path removal is not approved. |
| 29 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/parsers/__init__.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/parsers/__init__.py`; active-skill path removal is not approved. |
| 30 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/parsers/calibre.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/parsers/calibre.py`; active-skill path removal is not approved. |
| 31 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/parsers/docx.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/parsers/docx.py`; active-skill path removal is not approved. |
| 32 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/parsers/epub.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/parsers/epub.py`; active-skill path removal is not approved. |
| 33 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/parsers/html_text.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/parsers/html_text.py`; active-skill path removal is not approved. |
| 34 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/parsers/pdf.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/parsers/pdf.py`; active-skill path removal is not approved. |
| 35 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/parsers/rtf.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/parsers/rtf.py`; active-skill path removal is not approved. |
| 36 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/parsers/text.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/parsers/text.py`; active-skill path removal is not approved. |
| 37 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/sanitize.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/sanitize.py`; active-skill path removal is not approved. |
| 38 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/utils.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/utils.py`; active-skill path removal is not approved. |
| 39 | C | ` D` | `.agents/skills/book-to-skill/scripts/book_to_skill/zip_safety.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/book_to_skill/zip_safety.py`; active-skill path removal is not approved. |
| 40 | C | ` D` | `.agents/skills/book-to-skill/scripts/extract_document.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/extract_document.py`; active-skill path removal is not approved. |
| 41 | C | ` D` | `.agents/skills/book-to-skill/scripts/skill_plugin_emitter.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/skill_plugin_emitter.py`; active-skill path removal is not approved. |
| 42 | C | ` D` | `.agents/skills/book-to-skill/scripts/token_budget_estimator.py` | Cold copy: `.agents/skills-cold/book-to-skill/scripts/token_budget_estimator.py`; active-skill path removal is not approved. |
| 43 | C | ` D` | `.agents/skills/book-to-skill/SKILL.md` | Cold copy: `.agents/skills-cold/book-to-skill/SKILL.md`; active-skill path removal is not approved. |
| 44 | C | ` D` | `.agents/skills/database-designer/assets/sample_query_patterns.json` | Cold copy: `.agents/skills-cold/database-designer/assets/sample_query_patterns.json`; active-skill path removal is not approved. |
| 45 | C | ` D` | `.agents/skills/database-designer/assets/sample_schema.json` | Cold copy: `.agents/skills-cold/database-designer/assets/sample_schema.json`; active-skill path removal is not approved. |
| 46 | C | ` D` | `.agents/skills/database-designer/assets/sample_schema.sql` | Cold copy: `.agents/skills-cold/database-designer/assets/sample_schema.sql`; active-skill path removal is not approved. |
| 47 | C | ` D` | `.agents/skills/database-designer/expected_outputs/index_optimization_sample.txt` | Cold copy: `.agents/skills-cold/database-designer/expected_outputs/index_optimization_sample.txt`; active-skill path removal is not approved. |
| 48 | C | ` D` | `.agents/skills/database-designer/expected_outputs/migration_sample.txt` | Cold copy: `.agents/skills-cold/database-designer/expected_outputs/migration_sample.txt`; active-skill path removal is not approved. |
| 49 | C | ` D` | `.agents/skills/database-designer/expected_outputs/schema_analysis_sample.txt` | Cold copy: `.agents/skills-cold/database-designer/expected_outputs/schema_analysis_sample.txt`; active-skill path removal is not approved. |
| 50 | C | ` D` | `.agents/skills/database-designer/index_optimizer.py` | Cold copy: `.agents/skills-cold/database-designer/index_optimizer.py`; active-skill path removal is not approved. |
| 51 | C | ` D` | `.agents/skills/database-designer/migration_generator.py` | Cold copy: `.agents/skills-cold/database-designer/migration_generator.py`; active-skill path removal is not approved. |
| 52 | C | ` D` | `.agents/skills/database-designer/README.md` | Cold copy: `.agents/skills-cold/database-designer/README.md`; active-skill path removal is not approved. |
| 53 | C | ` D` | `.agents/skills/database-designer/references/database-design-reference.md` | Cold copy: `.agents/skills-cold/database-designer/references/database-design-reference.md`; active-skill path removal is not approved. |
| 54 | C | ` D` | `.agents/skills/database-designer/references/database_selection_decision_tree.md` | Cold copy: `.agents/skills-cold/database-designer/references/database_selection_decision_tree.md`; active-skill path removal is not approved. |
| 55 | C | ` D` | `.agents/skills/database-designer/references/index_strategy_patterns.md` | Cold copy: `.agents/skills-cold/database-designer/references/index_strategy_patterns.md`; active-skill path removal is not approved. |
| 56 | C | ` D` | `.agents/skills/database-designer/references/normalization_guide.md` | Cold copy: `.agents/skills-cold/database-designer/references/normalization_guide.md`; active-skill path removal is not approved. |
| 57 | C | ` D` | `.agents/skills/database-designer/schema_analyzer.py` | Cold copy: `.agents/skills-cold/database-designer/schema_analyzer.py`; active-skill path removal is not approved. |
| 58 | C | ` D` | `.agents/skills/database-designer/SKILL.md` | Cold copy: `.agents/skills-cold/database-designer/SKILL.md`; active-skill path removal is not approved. |
| 59 | C | ` D` | `.agents/skills/database-schema-designer/references/full-schema-examples.md` | Cold copy: `.agents/skills-cold/database-schema-designer/references/full-schema-examples.md`; active-skill path removal is not approved. |
| 60 | C | ` D` | `.agents/skills/database-schema-designer/SKILL.md` | Cold copy: `.agents/skills-cold/database-schema-designer/SKILL.md`; active-skill path removal is not approved. |
| 61 | C | ` D` | `.agents/skills/deep-learning-book/assets/chapter_worksheet.md` | Cold copy: `.agents/skills-cold/deep-learning-book/assets/chapter_worksheet.md`; active-skill path removal is not approved. |
| 62 | C | ` D` | `.agents/skills/deep-learning-book/assets/example_layer_spec.json` | Cold copy: `.agents/skills-cold/deep-learning-book/assets/example_layer_spec.json`; active-skill path removal is not approved. |
| 63 | C | ` D` | `.agents/skills/deep-learning-book/assets/study_log_template.md` | Cold copy: `.agents/skills-cold/deep-learning-book/assets/study_log_template.md`; active-skill path removal is not approved. |
| 64 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch01-introduction.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch01-introduction.md`; active-skill path removal is not approved. |
| 65 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch02-linear-algebra.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch02-linear-algebra.md`; active-skill path removal is not approved. |
| 66 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch03-probability-information-theory.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch03-probability-information-theory.md`; active-skill path removal is not approved. |
| 67 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch04-numerical-computation.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch04-numerical-computation.md`; active-skill path removal is not approved. |
| 68 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch05-machine-learning-basics.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch05-machine-learning-basics.md`; active-skill path removal is not approved. |
| 69 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch06-deep-feedforward-networks.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch06-deep-feedforward-networks.md`; active-skill path removal is not approved. |
| 70 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch07-regularization.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch07-regularization.md`; active-skill path removal is not approved. |
| 71 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch08-optimization.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch08-optimization.md`; active-skill path removal is not approved. |
| 72 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch09-convolutional-networks.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch09-convolutional-networks.md`; active-skill path removal is not approved. |
| 73 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch10-sequence-modeling.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch10-sequence-modeling.md`; active-skill path removal is not approved. |
| 74 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch11-practical-methodology.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch11-practical-methodology.md`; active-skill path removal is not approved. |
| 75 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch12-applications.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch12-applications.md`; active-skill path removal is not approved. |
| 76 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch13-linear-factor-models.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch13-linear-factor-models.md`; active-skill path removal is not approved. |
| 77 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch14-autoencoders.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch14-autoencoders.md`; active-skill path removal is not approved. |
| 78 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch15-representation-learning.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch15-representation-learning.md`; active-skill path removal is not approved. |
| 79 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch16-structured-probabilistic-models.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch16-structured-probabilistic-models.md`; active-skill path removal is not approved. |
| 80 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch17-monte-carlo-methods.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch17-monte-carlo-methods.md`; active-skill path removal is not approved. |
| 81 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch18-partition-function.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch18-partition-function.md`; active-skill path removal is not approved. |
| 82 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch19-approximate-inference.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch19-approximate-inference.md`; active-skill path removal is not approved. |
| 83 | C | ` D` | `.agents/skills/deep-learning-book/chapters/ch20-deep-generative-models.md` | Cold copy: `.agents/skills-cold/deep-learning-book/chapters/ch20-deep-generative-models.md`; active-skill path removal is not approved. |
| 84 | C | ` D` | `.agents/skills/deep-learning-book/cheatsheet.md` | Cold copy: `.agents/skills-cold/deep-learning-book/cheatsheet.md`; active-skill path removal is not approved. |
| 85 | C | ` D` | `.agents/skills/deep-learning-book/glossary.md` | Cold copy: `.agents/skills-cold/deep-learning-book/glossary.md`; active-skill path removal is not approved. |
| 86 | C | ` D` | `.agents/skills/deep-learning-book/patterns.md` | Cold copy: `.agents/skills-cold/deep-learning-book/patterns.md`; active-skill path removal is not approved. |
| 87 | C | ` D` | `.agents/skills/deep-learning-book/references/book_to_2026_delta.md` | Cold copy: `.agents/skills-cold/deep-learning-book/references/book_to_2026_delta.md`; active-skill path removal is not approved. |
| 88 | C | ` D` | `.agents/skills/deep-learning-book/references/prerequisite_map.md` | Cold copy: `.agents/skills-cold/deep-learning-book/references/prerequisite_map.md`; active-skill path removal is not approved. |
| 89 | C | ` D` | `.agents/skills/deep-learning-book/references/rights_and_use.md` | Cold copy: `.agents/skills-cold/deep-learning-book/references/rights_and_use.md`; active-skill path removal is not approved. |
| 90 | C | ` D` | `.agents/skills/deep-learning-book/references/study_method_canon.md` | Cold copy: `.agents/skills-cold/deep-learning-book/references/study_method_canon.md`; active-skill path removal is not approved. |
| 91 | C | ` D` | `.agents/skills/deep-learning-book/scripts/capacity_planner.py` | Cold copy: `.agents/skills-cold/deep-learning-book/scripts/capacity_planner.py`; active-skill path removal is not approved. |
| 92 | C | ` D` | `.agents/skills/deep-learning-book/scripts/model_arithmetic.py` | Cold copy: `.agents/skills-cold/deep-learning-book/scripts/model_arithmetic.py`; active-skill path removal is not approved. |
| 93 | C | ` D` | `.agents/skills/deep-learning-book/scripts/reading_path_planner.py` | Cold copy: `.agents/skills-cold/deep-learning-book/scripts/reading_path_planner.py`; active-skill path removal is not approved. |
| 94 | C | ` D` | `.agents/skills/deep-learning-book/scripts/training_diagnostics.py` | Cold copy: `.agents/skills-cold/deep-learning-book/scripts/training_diagnostics.py`; active-skill path removal is not approved. |
| 95 | C | ` D` | `.agents/skills/deep-learning-book/SKILL.md` | Cold copy: `.agents/skills-cold/deep-learning-book/SKILL.md`; active-skill path removal is not approved. |
| 96 | C | ` D` | `.agents/skills/deep-work/assets/example_time_block_plan.md` | Cold copy: `.agents/skills-cold/deep-work/assets/example_time_block_plan.md`; active-skill path removal is not approved. |
| 97 | C | ` D` | `.agents/skills/deep-work/assets/shutdown_checklist.md` | Cold copy: `.agents/skills-cold/deep-work/assets/shutdown_checklist.md`; active-skill path removal is not approved. |
| 98 | C | ` D` | `.agents/skills/deep-work/references/deep_work_canon.md` | Cold copy: `.agents/skills-cold/deep-work/references/deep_work_canon.md`; active-skill path removal is not approved. |
| 99 | C | ` D` | `.agents/skills/deep-work/references/shallow_work_budget.md` | Cold copy: `.agents/skills-cold/deep-work/references/shallow_work_budget.md`; active-skill path removal is not approved. |
| 100 | C | ` D` | `.agents/skills/deep-work/references/time_blocking_method.md` | Cold copy: `.agents/skills-cold/deep-work/references/time_blocking_method.md`; active-skill path removal is not approved. |
| 101 | C | ` D` | `.agents/skills/deep-work/scripts/focus_session_logger.py` | Cold copy: `.agents/skills-cold/deep-work/scripts/focus_session_logger.py`; active-skill path removal is not approved. |
| 102 | C | ` D` | `.agents/skills/deep-work/scripts/shallow_work_auditor.py` | Cold copy: `.agents/skills-cold/deep-work/scripts/shallow_work_auditor.py`; active-skill path removal is not approved. |
| 103 | C | ` D` | `.agents/skills/deep-work/scripts/time_block_planner.py` | Cold copy: `.agents/skills-cold/deep-work/scripts/time_block_planner.py`; active-skill path removal is not approved. |
| 104 | C | ` D` | `.agents/skills/deep-work/SKILL.md` | Cold copy: `.agents/skills-cold/deep-work/SKILL.md`; active-skill path removal is not approved. |
| 105 | C | ` D` | `.agents/skills/engineering-advanced-skills/SKILL.md` | Cold copy: `.agents/skills-cold/engineering-advanced-skills/SKILL.md`; active-skill path removal is not approved. |
| 106 | C | ` D` | `.agents/skills/json-canvas/references/EXAMPLES.md` | Cold copy: `.agents/skills-cold/json-canvas/references/EXAMPLES.md`; active-skill path removal is not approved. |
| 107 | C | ` D` | `.agents/skills/json-canvas/SKILL.md` | Cold copy: `.agents/skills-cold/json-canvas/SKILL.md`; active-skill path removal is not approved. |
| 108 | C | ` D` | `.agents/skills/knap/SKILL.md` | Cold copy: `.agents/skills-cold/knap/SKILL.md`; active-skill path removal is not approved. |
| 109 | C | ` D` | `.agents/skills/migration-architect/assets/database_schema_after.json` | Cold copy: `.agents/skills-cold/migration-architect/assets/database_schema_after.json`; active-skill path removal is not approved. |
| 110 | C | ` D` | `.agents/skills/migration-architect/assets/database_schema_before.json` | Cold copy: `.agents/skills-cold/migration-architect/assets/database_schema_before.json`; active-skill path removal is not approved. |
| 111 | C | ` D` | `.agents/skills/migration-architect/assets/sample_database_migration.json` | Cold copy: `.agents/skills-cold/migration-architect/assets/sample_database_migration.json`; active-skill path removal is not approved. |
| 112 | C | ` D` | `.agents/skills/migration-architect/assets/sample_service_migration.json` | Cold copy: `.agents/skills-cold/migration-architect/assets/sample_service_migration.json`; active-skill path removal is not approved. |
| 113 | C | ` D` | `.agents/skills/migration-architect/expected_outputs/rollback_runbook.json` | Cold copy: `.agents/skills-cold/migration-architect/expected_outputs/rollback_runbook.json`; active-skill path removal is not approved. |
| 114 | C | ` D` | `.agents/skills/migration-architect/expected_outputs/rollback_runbook.txt` | Cold copy: `.agents/skills-cold/migration-architect/expected_outputs/rollback_runbook.txt`; active-skill path removal is not approved. |
| 115 | C | ` D` | `.agents/skills/migration-architect/expected_outputs/sample_database_migration_plan.json` | Cold copy: `.agents/skills-cold/migration-architect/expected_outputs/sample_database_migration_plan.json`; active-skill path removal is not approved. |
| 116 | C | ` D` | `.agents/skills/migration-architect/expected_outputs/sample_database_migration_plan.txt` | Cold copy: `.agents/skills-cold/migration-architect/expected_outputs/sample_database_migration_plan.txt`; active-skill path removal is not approved. |
| 117 | C | ` D` | `.agents/skills/migration-architect/expected_outputs/sample_service_migration_plan.json` | Cold copy: `.agents/skills-cold/migration-architect/expected_outputs/sample_service_migration_plan.json`; active-skill path removal is not approved. |
| 118 | C | ` D` | `.agents/skills/migration-architect/expected_outputs/sample_service_migration_plan.txt` | Cold copy: `.agents/skills-cold/migration-architect/expected_outputs/sample_service_migration_plan.txt`; active-skill path removal is not approved. |
| 119 | C | ` D` | `.agents/skills/migration-architect/expected_outputs/schema_compatibility_report.json` | Cold copy: `.agents/skills-cold/migration-architect/expected_outputs/schema_compatibility_report.json`; active-skill path removal is not approved. |
| 120 | C | ` D` | `.agents/skills/migration-architect/expected_outputs/schema_compatibility_report.txt` | Cold copy: `.agents/skills-cold/migration-architect/expected_outputs/schema_compatibility_report.txt`; active-skill path removal is not approved. |
| 121 | C | ` D` | `.agents/skills/migration-architect/README.md` | Cold copy: `.agents/skills-cold/migration-architect/README.md`; active-skill path removal is not approved. |
| 122 | C | ` D` | `.agents/skills/migration-architect/references/data_reconciliation_strategies.md` | Cold copy: `.agents/skills-cold/migration-architect/references/data_reconciliation_strategies.md`; active-skill path removal is not approved. |
| 123 | C | ` D` | `.agents/skills/migration-architect/references/migration_patterns_catalog.md` | Cold copy: `.agents/skills-cold/migration-architect/references/migration_patterns_catalog.md`; active-skill path removal is not approved. |
| 124 | C | ` D` | `.agents/skills/migration-architect/references/zero_downtime_techniques.md` | Cold copy: `.agents/skills-cold/migration-architect/references/zero_downtime_techniques.md`; active-skill path removal is not approved. |
| 125 | C | ` D` | `.agents/skills/migration-architect/scripts/compatibility_checker.py` | Cold copy: `.agents/skills-cold/migration-architect/scripts/compatibility_checker.py`; active-skill path removal is not approved. |
| 126 | C | ` D` | `.agents/skills/migration-architect/scripts/migration_planner.py` | Cold copy: `.agents/skills-cold/migration-architect/scripts/migration_planner.py`; active-skill path removal is not approved. |
| 127 | C | ` D` | `.agents/skills/migration-architect/scripts/rollback_generator.py` | Cold copy: `.agents/skills-cold/migration-architect/scripts/rollback_generator.py`; active-skill path removal is not approved. |
| 128 | C | ` D` | `.agents/skills/migration-architect/SKILL.md` | Cold copy: `.agents/skills-cold/migration-architect/SKILL.md`; active-skill path removal is not approved. |
| 129 | C | ` D` | `.agents/skills/product-research/assets/research_plan_template.md` | Cold copy: `.agents/skills-cold/product-research/assets/research_plan_template.md`; active-skill path removal is not approved. |
| 130 | C | ` D` | `.agents/skills/product-research/references/repository_and_synthesis.md` | Cold copy: `.agents/skills-cold/product-research/references/repository_and_synthesis.md`; active-skill path removal is not approved. |
| 131 | C | ` D` | `.agents/skills/product-research/references/research_methods_canon.md` | Cold copy: `.agents/skills-cold/product-research/references/research_methods_canon.md`; active-skill path removal is not approved. |
| 132 | C | ` D` | `.agents/skills/product-research/references/sampling_and_saturation.md` | Cold copy: `.agents/skills-cold/product-research/references/sampling_and_saturation.md`; active-skill path removal is not approved. |
| 133 | C | ` D` | `.agents/skills/product-research/scripts/ar_evaluator.py` | Cold copy: `.agents/skills-cold/product-research/scripts/ar_evaluator.py`; active-skill path removal is not approved. |
| 134 | C | ` D` | `.agents/skills/product-research/scripts/config_loader.py` | Cold copy: `.agents/skills-cold/product-research/scripts/config_loader.py`; active-skill path removal is not approved. |
| 135 | C | ` D` | `.agents/skills/product-research/scripts/insight_synthesizer.py` | Cold copy: `.agents/skills-cold/product-research/scripts/insight_synthesizer.py`; active-skill path removal is not approved. |
| 136 | C | ` D` | `.agents/skills/product-research/scripts/onboard.py` | Cold copy: `.agents/skills-cold/product-research/scripts/onboard.py`; active-skill path removal is not approved. |
| 137 | C | ` D` | `.agents/skills/product-research/scripts/saturation_planner.py` | Cold copy: `.agents/skills-cold/product-research/scripts/saturation_planner.py`; active-skill path removal is not approved. |
| 138 | C | ` D` | `.agents/skills/product-research/scripts/study_designer.py` | Cold copy: `.agents/skills-cold/product-research/scripts/study_designer.py`; active-skill path removal is not approved. |
| 139 | C | ` D` | `.agents/skills/product-research/SKILL.md` | Cold copy: `.agents/skills-cold/product-research/SKILL.md`; active-skill path removal is not approved. |
| 140 | C | ` D` | `.agents/skills/research-summarizer/references/citation-formats.md` | Cold copy: `.agents/skills-cold/research-summarizer/references/citation-formats.md`; active-skill path removal is not approved. |
| 141 | C | ` D` | `.agents/skills/research-summarizer/references/summary-templates.md` | Cold copy: `.agents/skills-cold/research-summarizer/references/summary-templates.md`; active-skill path removal is not approved. |
| 142 | C | ` D` | `.agents/skills/research-summarizer/scripts/extract_citations.py` | Cold copy: `.agents/skills-cold/research-summarizer/scripts/extract_citations.py`; active-skill path removal is not approved. |
| 143 | C | ` D` | `.agents/skills/research-summarizer/scripts/format_summary.py` | Cold copy: `.agents/skills-cold/research-summarizer/scripts/format_summary.py`; active-skill path removal is not approved. |
| 144 | C | ` D` | `.agents/skills/research-summarizer/SKILL.md` | Cold copy: `.agents/skills-cold/research-summarizer/SKILL.md`; active-skill path removal is not approved. |
| 145 | C | ` D` | `.agents/skills/self-improving-agent/SKILL.md` | Cold copy: `.agents/skills-cold/self-improving-agent/SKILL.md`; active-skill path removal is not approved. |
| 146 | C | ` D` | `.agents/skills/sql-database-assistant/references/optimization_guide.md` | Cold copy: `.agents/skills-cold/sql-database-assistant/references/optimization_guide.md`; active-skill path removal is not approved. |
| 147 | C | ` D` | `.agents/skills/sql-database-assistant/references/orm_patterns.md` | Cold copy: `.agents/skills-cold/sql-database-assistant/references/orm_patterns.md`; active-skill path removal is not approved. |
| 148 | C | ` D` | `.agents/skills/sql-database-assistant/references/query_patterns.md` | Cold copy: `.agents/skills-cold/sql-database-assistant/references/query_patterns.md`; active-skill path removal is not approved. |
| 149 | C | ` D` | `.agents/skills/sql-database-assistant/scripts/migration_generator.py` | Cold copy: `.agents/skills-cold/sql-database-assistant/scripts/migration_generator.py`; active-skill path removal is not approved. |
| 150 | C | ` D` | `.agents/skills/sql-database-assistant/scripts/query_optimizer.py` | Cold copy: `.agents/skills-cold/sql-database-assistant/scripts/query_optimizer.py`; active-skill path removal is not approved. |
| 151 | C | ` D` | `.agents/skills/sql-database-assistant/scripts/schema_explorer.py` | Cold copy: `.agents/skills-cold/sql-database-assistant/scripts/schema_explorer.py`; active-skill path removal is not approved. |
| 152 | C | ` D` | `.agents/skills/sql-database-assistant/SKILL.md` | Cold copy: `.agents/skills-cold/sql-database-assistant/SKILL.md`; active-skill path removal is not approved. |
| 153 | C | ` D` | `.agents/skills/ux-researcher-designer/assets/research_plan_template.md` | Cold copy: `.agents/skills-cold/ux-researcher-designer/assets/research_plan_template.md`; active-skill path removal is not approved. |
| 154 | C | ` D` | `.agents/skills/ux-researcher-designer/references/example-personas.md` | Cold copy: `.agents/skills-cold/ux-researcher-designer/references/example-personas.md`; active-skill path removal is not approved. |
| 155 | C | ` D` | `.agents/skills/ux-researcher-designer/references/journey-mapping-guide.md` | Cold copy: `.agents/skills-cold/ux-researcher-designer/references/journey-mapping-guide.md`; active-skill path removal is not approved. |
| 156 | C | ` D` | `.agents/skills/ux-researcher-designer/references/persona-methodology.md` | Cold copy: `.agents/skills-cold/ux-researcher-designer/references/persona-methodology.md`; active-skill path removal is not approved. |
| 157 | C | ` D` | `.agents/skills/ux-researcher-designer/references/usability-testing-frameworks.md` | Cold copy: `.agents/skills-cold/ux-researcher-designer/references/usability-testing-frameworks.md`; active-skill path removal is not approved. |
| 158 | C | ` D` | `.agents/skills/ux-researcher-designer/scripts/persona_generator.py` | Cold copy: `.agents/skills-cold/ux-researcher-designer/scripts/persona_generator.py`; active-skill path removal is not approved. |
| 159 | C | ` D` | `.agents/skills/ux-researcher-designer/SKILL.md` | Cold copy: `.agents/skills-cold/ux-researcher-designer/SKILL.md`; active-skill path removal is not approved. |
| 160 | C | ` D` | `.agents/skills/weekly-review/assets/example_weekly_review.md` | Cold copy: `.agents/skills-cold/weekly-review/assets/example_weekly_review.md`; active-skill path removal is not approved. |
| 161 | C | ` D` | `.agents/skills/weekly-review/assets/weekly_review_checklist.md` | Cold copy: `.agents/skills-cold/weekly-review/assets/weekly_review_checklist.md`; active-skill path removal is not approved. |
| 162 | C | ` D` | `.agents/skills/weekly-review/references/gtd_weekly_review_canon.md` | Cold copy: `.agents/skills-cold/weekly-review/references/gtd_weekly_review_canon.md`; active-skill path removal is not approved. |
| 163 | C | ` D` | `.agents/skills/weekly-review/references/open_loop_psychology.md` | Cold copy: `.agents/skills-cold/weekly-review/references/open_loop_psychology.md`; active-skill path removal is not approved. |
| 164 | C | ` D` | `.agents/skills/weekly-review/references/review_cadence_design.md` | Cold copy: `.agents/skills-cold/weekly-review/references/review_cadence_design.md`; active-skill path removal is not approved. |
| 165 | C | ` D` | `.agents/skills/weekly-review/scripts/commitment_auditor.py` | Cold copy: `.agents/skills-cold/weekly-review/scripts/commitment_auditor.py`; active-skill path removal is not approved. |
| 166 | C | ` D` | `.agents/skills/weekly-review/scripts/open_loop_scanner.py` | Cold copy: `.agents/skills-cold/weekly-review/scripts/open_loop_scanner.py`; active-skill path removal is not approved. |
| 167 | C | ` D` | `.agents/skills/weekly-review/scripts/weekly_review_gate.py` | Cold copy: `.agents/skills-cold/weekly-review/scripts/weekly_review_gate.py`; active-skill path removal is not approved. |
| 168 | C | ` D` | `.agents/skills/weekly-review/SKILL.md` | Cold copy: `.agents/skills-cold/weekly-review/SKILL.md`; active-skill path removal is not approved. |
| 169 | C | ` D` | `.github/skills/agent-protocol/references/invocation-patterns.md` | Cold copy: `.github/skills-cold/agent-protocol/references/invocation-patterns.md`; active-skill path removal is not approved. |
| 170 | C | ` D` | `.github/skills/agent-protocol/SKILL.md` | Cold copy: `.github/skills-cold/agent-protocol/SKILL.md`; active-skill path removal is not approved. |
| 171 | C | ` D` | `.github/skills/agent-run-forensics/assets/claims_example.txt` | Cold copy: `.github/skills-cold/agent-run-forensics/assets/claims_example.txt`; active-skill path removal is not approved. |
| 172 | C | ` D` | `.github/skills/agent-run-forensics/assets/forensic_answer_template.md` | Cold copy: `.github/skills-cold/agent-run-forensics/assets/forensic_answer_template.md`; active-skill path removal is not approved. |
| 173 | C | ` D` | `.github/skills/agent-run-forensics/references/claim_verification.md` | Cold copy: `.github/skills-cold/agent-run-forensics/references/claim_verification.md`; active-skill path removal is not approved. |
| 174 | C | ` D` | `.github/skills/agent-run-forensics/references/recorded_vs_inferred.md` | Cold copy: `.github/skills-cold/agent-run-forensics/references/recorded_vs_inferred.md`; active-skill path removal is not approved. |
| 175 | C | ` D` | `.github/skills/agent-run-forensics/references/trace_sources.md` | Cold copy: `.github/skills-cold/agent-run-forensics/references/trace_sources.md`; active-skill path removal is not approved. |
| 176 | C | ` D` | `.github/skills/agent-run-forensics/scripts/claim_checker.py` | Cold copy: `.github/skills-cold/agent-run-forensics/scripts/claim_checker.py`; active-skill path removal is not approved. |
| 177 | C | ` D` | `.github/skills/agent-run-forensics/scripts/trace_core.py` | Cold copy: `.github/skills-cold/agent-run-forensics/scripts/trace_core.py`; active-skill path removal is not approved. |
| 178 | C | ` D` | `.github/skills/agent-run-forensics/scripts/trace_finder.py` | Cold copy: `.github/skills-cold/agent-run-forensics/scripts/trace_finder.py`; active-skill path removal is not approved. |
| 179 | C | ` D` | `.github/skills/agent-run-forensics/scripts/trace_timeline.py` | Cold copy: `.github/skills-cold/agent-run-forensics/scripts/trace_timeline.py`; active-skill path removal is not approved. |
| 180 | C | ` D` | `.github/skills/agent-run-forensics/SKILL.md` | Cold copy: `.github/skills-cold/agent-run-forensics/SKILL.md`; active-skill path removal is not approved. |
| 181 | C | ` D` | `.github/skills/agent-workflow-designer/references/workflow-patterns.md` | Cold copy: `.github/skills-cold/agent-workflow-designer/references/workflow-patterns.md`; active-skill path removal is not approved. |
| 182 | C | ` D` | `.github/skills/agent-workflow-designer/scripts/workflow_scaffolder.py` | Cold copy: `.github/skills-cold/agent-workflow-designer/scripts/workflow_scaffolder.py`; active-skill path removal is not approved. |
| 183 | C | ` D` | `.github/skills/agent-workflow-designer/SKILL.md` | Cold copy: `.github/skills-cold/agent-workflow-designer/SKILL.md`; active-skill path removal is not approved. |
| 184 | C | ` D` | `.github/skills/book-to-skill/assets/chapter_template.md` | Cold copy: `.github/skills-cold/book-to-skill/assets/chapter_template.md`; active-skill path removal is not approved. |
| 185 | C | ` D` | `.github/skills/book-to-skill/assets/cheatsheet_template.md` | Cold copy: `.github/skills-cold/book-to-skill/assets/cheatsheet_template.md`; active-skill path removal is not approved. |
| 186 | C | ` D` | `.github/skills/book-to-skill/assets/master_skill_template.md` | Cold copy: `.github/skills-cold/book-to-skill/assets/master_skill_template.md`; active-skill path removal is not approved. |
| 187 | C | ` D` | `.github/skills/book-to-skill/references/conversion_workflow.md` | Cold copy: `.github/skills-cold/book-to-skill/references/conversion_workflow.md`; active-skill path removal is not approved. |
| 188 | C | ` D` | `.github/skills/book-to-skill/references/document_extraction_pipeline.md` | Cold copy: `.github/skills-cold/book-to-skill/references/document_extraction_pipeline.md`; active-skill path removal is not approved. |
| 189 | C | ` D` | `.github/skills/book-to-skill/references/knowledge_extraction_canon.md` | Cold copy: `.github/skills-cold/book-to-skill/references/knowledge_extraction_canon.md`; active-skill path removal is not approved. |
| 190 | C | ` D` | `.github/skills/book-to-skill/references/progressive_disclosure_budgets.md` | Cold copy: `.github/skills-cold/book-to-skill/references/progressive_disclosure_budgets.md`; active-skill path removal is not approved. |
| 191 | C | ` D` | `.github/skills/book-to-skill/references/rights_and_provenance.md` | Cold copy: `.github/skills-cold/book-to-skill/references/rights_and_provenance.md`; active-skill path removal is not approved. |
| 192 | C | ` D` | `.github/skills/book-to-skill/scripts/book_skill_validator.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_skill_validator.py`; active-skill path removal is not approved. |
| 193 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/__init__.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/__init__.py`; active-skill path removal is not approved. |
| 194 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/config.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/config.py`; active-skill path removal is not approved. |
| 195 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/dependencies.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/dependencies.py`; active-skill path removal is not approved. |
| 196 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/exceptions.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/exceptions.py`; active-skill path removal is not approved. |
| 197 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/parsers/__init__.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/parsers/__init__.py`; active-skill path removal is not approved. |
| 198 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/parsers/calibre.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/parsers/calibre.py`; active-skill path removal is not approved. |
| 199 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/parsers/docx.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/parsers/docx.py`; active-skill path removal is not approved. |
| 200 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/parsers/epub.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/parsers/epub.py`; active-skill path removal is not approved. |
| 201 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/parsers/html_text.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/parsers/html_text.py`; active-skill path removal is not approved. |
| 202 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/parsers/pdf.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/parsers/pdf.py`; active-skill path removal is not approved. |
| 203 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/parsers/rtf.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/parsers/rtf.py`; active-skill path removal is not approved. |
| 204 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/parsers/text.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/parsers/text.py`; active-skill path removal is not approved. |
| 205 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/sanitize.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/sanitize.py`; active-skill path removal is not approved. |
| 206 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/utils.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/utils.py`; active-skill path removal is not approved. |
| 207 | C | ` D` | `.github/skills/book-to-skill/scripts/book_to_skill/zip_safety.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/book_to_skill/zip_safety.py`; active-skill path removal is not approved. |
| 208 | C | ` D` | `.github/skills/book-to-skill/scripts/extract_document.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/extract_document.py`; active-skill path removal is not approved. |
| 209 | C | ` D` | `.github/skills/book-to-skill/scripts/skill_plugin_emitter.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/skill_plugin_emitter.py`; active-skill path removal is not approved. |
| 210 | C | ` D` | `.github/skills/book-to-skill/scripts/token_budget_estimator.py` | Cold copy: `.github/skills-cold/book-to-skill/scripts/token_budget_estimator.py`; active-skill path removal is not approved. |
| 211 | C | ` D` | `.github/skills/book-to-skill/SKILL.md` | Cold copy: `.github/skills-cold/book-to-skill/SKILL.md`; active-skill path removal is not approved. |
| 212 | C | ` D` | `.github/skills/database-designer/assets/sample_query_patterns.json` | Cold copy: `.github/skills-cold/database-designer/assets/sample_query_patterns.json`; active-skill path removal is not approved. |
| 213 | C | ` D` | `.github/skills/database-designer/assets/sample_schema.json` | Cold copy: `.github/skills-cold/database-designer/assets/sample_schema.json`; active-skill path removal is not approved. |
| 214 | C | ` D` | `.github/skills/database-designer/assets/sample_schema.sql` | Cold copy: `.github/skills-cold/database-designer/assets/sample_schema.sql`; active-skill path removal is not approved. |
| 215 | C | ` D` | `.github/skills/database-designer/expected_outputs/index_optimization_sample.txt` | Cold copy: `.github/skills-cold/database-designer/expected_outputs/index_optimization_sample.txt`; active-skill path removal is not approved. |
| 216 | C | ` D` | `.github/skills/database-designer/expected_outputs/migration_sample.txt` | Cold copy: `.github/skills-cold/database-designer/expected_outputs/migration_sample.txt`; active-skill path removal is not approved. |
| 217 | C | ` D` | `.github/skills/database-designer/expected_outputs/schema_analysis_sample.txt` | Cold copy: `.github/skills-cold/database-designer/expected_outputs/schema_analysis_sample.txt`; active-skill path removal is not approved. |
| 218 | C | ` D` | `.github/skills/database-designer/index_optimizer.py` | Cold copy: `.github/skills-cold/database-designer/index_optimizer.py`; active-skill path removal is not approved. |
| 219 | C | ` D` | `.github/skills/database-designer/migration_generator.py` | Cold copy: `.github/skills-cold/database-designer/migration_generator.py`; active-skill path removal is not approved. |
| 220 | C | ` D` | `.github/skills/database-designer/README.md` | Cold copy: `.github/skills-cold/database-designer/README.md`; active-skill path removal is not approved. |
| 221 | C | ` D` | `.github/skills/database-designer/references/database-design-reference.md` | Cold copy: `.github/skills-cold/database-designer/references/database-design-reference.md`; active-skill path removal is not approved. |
| 222 | C | ` D` | `.github/skills/database-designer/references/database_selection_decision_tree.md` | Cold copy: `.github/skills-cold/database-designer/references/database_selection_decision_tree.md`; active-skill path removal is not approved. |
| 223 | C | ` D` | `.github/skills/database-designer/references/index_strategy_patterns.md` | Cold copy: `.github/skills-cold/database-designer/references/index_strategy_patterns.md`; active-skill path removal is not approved. |
| 224 | C | ` D` | `.github/skills/database-designer/references/normalization_guide.md` | Cold copy: `.github/skills-cold/database-designer/references/normalization_guide.md`; active-skill path removal is not approved. |
| 225 | C | ` D` | `.github/skills/database-designer/schema_analyzer.py` | Cold copy: `.github/skills-cold/database-designer/schema_analyzer.py`; active-skill path removal is not approved. |
| 226 | C | ` D` | `.github/skills/database-designer/SKILL.md` | Cold copy: `.github/skills-cold/database-designer/SKILL.md`; active-skill path removal is not approved. |
| 227 | C | ` D` | `.github/skills/database-schema-designer/references/full-schema-examples.md` | Cold copy: `.github/skills-cold/database-schema-designer/references/full-schema-examples.md`; active-skill path removal is not approved. |
| 228 | C | ` D` | `.github/skills/database-schema-designer/SKILL.md` | Cold copy: `.github/skills-cold/database-schema-designer/SKILL.md`; active-skill path removal is not approved. |
| 229 | C | ` D` | `.github/skills/deep-learning-book/assets/chapter_worksheet.md` | Cold copy: `.github/skills-cold/deep-learning-book/assets/chapter_worksheet.md`; active-skill path removal is not approved. |
| 230 | C | ` D` | `.github/skills/deep-learning-book/assets/example_layer_spec.json` | Cold copy: `.github/skills-cold/deep-learning-book/assets/example_layer_spec.json`; active-skill path removal is not approved. |
| 231 | C | ` D` | `.github/skills/deep-learning-book/assets/study_log_template.md` | Cold copy: `.github/skills-cold/deep-learning-book/assets/study_log_template.md`; active-skill path removal is not approved. |
| 232 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch01-introduction.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch01-introduction.md`; active-skill path removal is not approved. |
| 233 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch02-linear-algebra.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch02-linear-algebra.md`; active-skill path removal is not approved. |
| 234 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch03-probability-information-theory.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch03-probability-information-theory.md`; active-skill path removal is not approved. |
| 235 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch04-numerical-computation.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch04-numerical-computation.md`; active-skill path removal is not approved. |
| 236 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch05-machine-learning-basics.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch05-machine-learning-basics.md`; active-skill path removal is not approved. |
| 237 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch06-deep-feedforward-networks.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch06-deep-feedforward-networks.md`; active-skill path removal is not approved. |
| 238 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch07-regularization.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch07-regularization.md`; active-skill path removal is not approved. |
| 239 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch08-optimization.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch08-optimization.md`; active-skill path removal is not approved. |
| 240 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch09-convolutional-networks.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch09-convolutional-networks.md`; active-skill path removal is not approved. |
| 241 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch10-sequence-modeling.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch10-sequence-modeling.md`; active-skill path removal is not approved. |
| 242 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch11-practical-methodology.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch11-practical-methodology.md`; active-skill path removal is not approved. |
| 243 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch12-applications.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch12-applications.md`; active-skill path removal is not approved. |
| 244 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch13-linear-factor-models.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch13-linear-factor-models.md`; active-skill path removal is not approved. |
| 245 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch14-autoencoders.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch14-autoencoders.md`; active-skill path removal is not approved. |
| 246 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch15-representation-learning.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch15-representation-learning.md`; active-skill path removal is not approved. |
| 247 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch16-structured-probabilistic-models.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch16-structured-probabilistic-models.md`; active-skill path removal is not approved. |
| 248 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch17-monte-carlo-methods.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch17-monte-carlo-methods.md`; active-skill path removal is not approved. |
| 249 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch18-partition-function.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch18-partition-function.md`; active-skill path removal is not approved. |
| 250 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch19-approximate-inference.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch19-approximate-inference.md`; active-skill path removal is not approved. |
| 251 | C | ` D` | `.github/skills/deep-learning-book/chapters/ch20-deep-generative-models.md` | Cold copy: `.github/skills-cold/deep-learning-book/chapters/ch20-deep-generative-models.md`; active-skill path removal is not approved. |
| 252 | C | ` D` | `.github/skills/deep-learning-book/cheatsheet.md` | Cold copy: `.github/skills-cold/deep-learning-book/cheatsheet.md`; active-skill path removal is not approved. |
| 253 | C | ` D` | `.github/skills/deep-learning-book/glossary.md` | Cold copy: `.github/skills-cold/deep-learning-book/glossary.md`; active-skill path removal is not approved. |
| 254 | C | ` D` | `.github/skills/deep-learning-book/patterns.md` | Cold copy: `.github/skills-cold/deep-learning-book/patterns.md`; active-skill path removal is not approved. |
| 255 | C | ` D` | `.github/skills/deep-learning-book/references/book_to_2026_delta.md` | Cold copy: `.github/skills-cold/deep-learning-book/references/book_to_2026_delta.md`; active-skill path removal is not approved. |
| 256 | C | ` D` | `.github/skills/deep-learning-book/references/prerequisite_map.md` | Cold copy: `.github/skills-cold/deep-learning-book/references/prerequisite_map.md`; active-skill path removal is not approved. |
| 257 | C | ` D` | `.github/skills/deep-learning-book/references/rights_and_use.md` | Cold copy: `.github/skills-cold/deep-learning-book/references/rights_and_use.md`; active-skill path removal is not approved. |
| 258 | C | ` D` | `.github/skills/deep-learning-book/references/study_method_canon.md` | Cold copy: `.github/skills-cold/deep-learning-book/references/study_method_canon.md`; active-skill path removal is not approved. |
| 259 | C | ` D` | `.github/skills/deep-learning-book/scripts/capacity_planner.py` | Cold copy: `.github/skills-cold/deep-learning-book/scripts/capacity_planner.py`; active-skill path removal is not approved. |
| 260 | C | ` D` | `.github/skills/deep-learning-book/scripts/model_arithmetic.py` | Cold copy: `.github/skills-cold/deep-learning-book/scripts/model_arithmetic.py`; active-skill path removal is not approved. |
| 261 | C | ` D` | `.github/skills/deep-learning-book/scripts/reading_path_planner.py` | Cold copy: `.github/skills-cold/deep-learning-book/scripts/reading_path_planner.py`; active-skill path removal is not approved. |
| 262 | C | ` D` | `.github/skills/deep-learning-book/scripts/training_diagnostics.py` | Cold copy: `.github/skills-cold/deep-learning-book/scripts/training_diagnostics.py`; active-skill path removal is not approved. |
| 263 | C | ` D` | `.github/skills/deep-learning-book/SKILL.md` | Cold copy: `.github/skills-cold/deep-learning-book/SKILL.md`; active-skill path removal is not approved. |
| 264 | C | ` D` | `.github/skills/deep-work/assets/example_time_block_plan.md` | Cold copy: `.github/skills-cold/deep-work/assets/example_time_block_plan.md`; active-skill path removal is not approved. |
| 265 | C | ` D` | `.github/skills/deep-work/assets/shutdown_checklist.md` | Cold copy: `.github/skills-cold/deep-work/assets/shutdown_checklist.md`; active-skill path removal is not approved. |
| 266 | C | ` D` | `.github/skills/deep-work/references/deep_work_canon.md` | Cold copy: `.github/skills-cold/deep-work/references/deep_work_canon.md`; active-skill path removal is not approved. |
| 267 | C | ` D` | `.github/skills/deep-work/references/shallow_work_budget.md` | Cold copy: `.github/skills-cold/deep-work/references/shallow_work_budget.md`; active-skill path removal is not approved. |
| 268 | C | ` D` | `.github/skills/deep-work/references/time_blocking_method.md` | Cold copy: `.github/skills-cold/deep-work/references/time_blocking_method.md`; active-skill path removal is not approved. |
| 269 | C | ` D` | `.github/skills/deep-work/scripts/focus_session_logger.py` | Cold copy: `.github/skills-cold/deep-work/scripts/focus_session_logger.py`; active-skill path removal is not approved. |
| 270 | C | ` D` | `.github/skills/deep-work/scripts/shallow_work_auditor.py` | Cold copy: `.github/skills-cold/deep-work/scripts/shallow_work_auditor.py`; active-skill path removal is not approved. |
| 271 | C | ` D` | `.github/skills/deep-work/scripts/time_block_planner.py` | Cold copy: `.github/skills-cold/deep-work/scripts/time_block_planner.py`; active-skill path removal is not approved. |
| 272 | C | ` D` | `.github/skills/deep-work/SKILL.md` | Cold copy: `.github/skills-cold/deep-work/SKILL.md`; active-skill path removal is not approved. |
| 273 | C | ` D` | `.github/skills/engineering-advanced-skills/SKILL.md` | Cold copy: `.github/skills-cold/engineering-advanced-skills/SKILL.md`; active-skill path removal is not approved. |
| 274 | C | ` D` | `.github/skills/json-canvas/references/EXAMPLES.md` | Cold copy: `.github/skills-cold/json-canvas/references/EXAMPLES.md`; active-skill path removal is not approved. |
| 275 | C | ` D` | `.github/skills/json-canvas/SKILL.md` | Cold copy: `.github/skills-cold/json-canvas/SKILL.md`; active-skill path removal is not approved. |
| 276 | C | ` D` | `.github/skills/knap/SKILL.md` | Cold copy: `.github/skills-cold/knap/SKILL.md`; active-skill path removal is not approved. |
| 277 | C | ` D` | `.github/skills/migration-architect/assets/database_schema_after.json` | Cold copy: `.github/skills-cold/migration-architect/assets/database_schema_after.json`; active-skill path removal is not approved. |
| 278 | C | ` D` | `.github/skills/migration-architect/assets/database_schema_before.json` | Cold copy: `.github/skills-cold/migration-architect/assets/database_schema_before.json`; active-skill path removal is not approved. |
| 279 | C | ` D` | `.github/skills/migration-architect/assets/sample_database_migration.json` | Cold copy: `.github/skills-cold/migration-architect/assets/sample_database_migration.json`; active-skill path removal is not approved. |
| 280 | C | ` D` | `.github/skills/migration-architect/assets/sample_service_migration.json` | Cold copy: `.github/skills-cold/migration-architect/assets/sample_service_migration.json`; active-skill path removal is not approved. |
| 281 | C | ` D` | `.github/skills/migration-architect/expected_outputs/rollback_runbook.json` | Cold copy: `.github/skills-cold/migration-architect/expected_outputs/rollback_runbook.json`; active-skill path removal is not approved. |
| 282 | C | ` D` | `.github/skills/migration-architect/expected_outputs/rollback_runbook.txt` | Cold copy: `.github/skills-cold/migration-architect/expected_outputs/rollback_runbook.txt`; active-skill path removal is not approved. |
| 283 | C | ` D` | `.github/skills/migration-architect/expected_outputs/sample_database_migration_plan.json` | Cold copy: `.github/skills-cold/migration-architect/expected_outputs/sample_database_migration_plan.json`; active-skill path removal is not approved. |
| 284 | C | ` D` | `.github/skills/migration-architect/expected_outputs/sample_database_migration_plan.txt` | Cold copy: `.github/skills-cold/migration-architect/expected_outputs/sample_database_migration_plan.txt`; active-skill path removal is not approved. |
| 285 | C | ` D` | `.github/skills/migration-architect/expected_outputs/sample_service_migration_plan.json` | Cold copy: `.github/skills-cold/migration-architect/expected_outputs/sample_service_migration_plan.json`; active-skill path removal is not approved. |
| 286 | C | ` D` | `.github/skills/migration-architect/expected_outputs/sample_service_migration_plan.txt` | Cold copy: `.github/skills-cold/migration-architect/expected_outputs/sample_service_migration_plan.txt`; active-skill path removal is not approved. |
| 287 | C | ` D` | `.github/skills/migration-architect/expected_outputs/schema_compatibility_report.json` | Cold copy: `.github/skills-cold/migration-architect/expected_outputs/schema_compatibility_report.json`; active-skill path removal is not approved. |
| 288 | C | ` D` | `.github/skills/migration-architect/expected_outputs/schema_compatibility_report.txt` | Cold copy: `.github/skills-cold/migration-architect/expected_outputs/schema_compatibility_report.txt`; active-skill path removal is not approved. |
| 289 | C | ` D` | `.github/skills/migration-architect/README.md` | Cold copy: `.github/skills-cold/migration-architect/README.md`; active-skill path removal is not approved. |
| 290 | C | ` D` | `.github/skills/migration-architect/references/data_reconciliation_strategies.md` | Cold copy: `.github/skills-cold/migration-architect/references/data_reconciliation_strategies.md`; active-skill path removal is not approved. |
| 291 | C | ` D` | `.github/skills/migration-architect/references/migration_patterns_catalog.md` | Cold copy: `.github/skills-cold/migration-architect/references/migration_patterns_catalog.md`; active-skill path removal is not approved. |
| 292 | C | ` D` | `.github/skills/migration-architect/references/zero_downtime_techniques.md` | Cold copy: `.github/skills-cold/migration-architect/references/zero_downtime_techniques.md`; active-skill path removal is not approved. |
| 293 | C | ` D` | `.github/skills/migration-architect/scripts/compatibility_checker.py` | Cold copy: `.github/skills-cold/migration-architect/scripts/compatibility_checker.py`; active-skill path removal is not approved. |
| 294 | C | ` D` | `.github/skills/migration-architect/scripts/migration_planner.py` | Cold copy: `.github/skills-cold/migration-architect/scripts/migration_planner.py`; active-skill path removal is not approved. |
| 295 | C | ` D` | `.github/skills/migration-architect/scripts/rollback_generator.py` | Cold copy: `.github/skills-cold/migration-architect/scripts/rollback_generator.py`; active-skill path removal is not approved. |
| 296 | C | ` D` | `.github/skills/migration-architect/SKILL.md` | Cold copy: `.github/skills-cold/migration-architect/SKILL.md`; active-skill path removal is not approved. |
| 297 | C | ` D` | `.github/skills/product-research/assets/research_plan_template.md` | Cold copy: `.github/skills-cold/product-research/assets/research_plan_template.md`; active-skill path removal is not approved. |
| 298 | C | ` D` | `.github/skills/product-research/references/repository_and_synthesis.md` | Cold copy: `.github/skills-cold/product-research/references/repository_and_synthesis.md`; active-skill path removal is not approved. |
| 299 | C | ` D` | `.github/skills/product-research/references/research_methods_canon.md` | Cold copy: `.github/skills-cold/product-research/references/research_methods_canon.md`; active-skill path removal is not approved. |
| 300 | C | ` D` | `.github/skills/product-research/references/sampling_and_saturation.md` | Cold copy: `.github/skills-cold/product-research/references/sampling_and_saturation.md`; active-skill path removal is not approved. |
| 301 | C | ` D` | `.github/skills/product-research/scripts/ar_evaluator.py` | Cold copy: `.github/skills-cold/product-research/scripts/ar_evaluator.py`; active-skill path removal is not approved. |
| 302 | C | ` D` | `.github/skills/product-research/scripts/config_loader.py` | Cold copy: `.github/skills-cold/product-research/scripts/config_loader.py`; active-skill path removal is not approved. |
| 303 | C | ` D` | `.github/skills/product-research/scripts/insight_synthesizer.py` | Cold copy: `.github/skills-cold/product-research/scripts/insight_synthesizer.py`; active-skill path removal is not approved. |
| 304 | C | ` D` | `.github/skills/product-research/scripts/onboard.py` | Cold copy: `.github/skills-cold/product-research/scripts/onboard.py`; active-skill path removal is not approved. |
| 305 | C | ` D` | `.github/skills/product-research/scripts/saturation_planner.py` | Cold copy: `.github/skills-cold/product-research/scripts/saturation_planner.py`; active-skill path removal is not approved. |
| 306 | C | ` D` | `.github/skills/product-research/scripts/study_designer.py` | Cold copy: `.github/skills-cold/product-research/scripts/study_designer.py`; active-skill path removal is not approved. |
| 307 | C | ` D` | `.github/skills/product-research/SKILL.md` | Cold copy: `.github/skills-cold/product-research/SKILL.md`; active-skill path removal is not approved. |
| 308 | C | ` D` | `.github/skills/research-summarizer/references/citation-formats.md` | Cold copy: `.github/skills-cold/research-summarizer/references/citation-formats.md`; active-skill path removal is not approved. |
| 309 | C | ` D` | `.github/skills/research-summarizer/references/summary-templates.md` | Cold copy: `.github/skills-cold/research-summarizer/references/summary-templates.md`; active-skill path removal is not approved. |
| 310 | C | ` D` | `.github/skills/research-summarizer/scripts/extract_citations.py` | Cold copy: `.github/skills-cold/research-summarizer/scripts/extract_citations.py`; active-skill path removal is not approved. |
| 311 | C | ` D` | `.github/skills/research-summarizer/scripts/format_summary.py` | Cold copy: `.github/skills-cold/research-summarizer/scripts/format_summary.py`; active-skill path removal is not approved. |
| 312 | C | ` D` | `.github/skills/research-summarizer/SKILL.md` | Cold copy: `.github/skills-cold/research-summarizer/SKILL.md`; active-skill path removal is not approved. |
| 313 | C | ` D` | `.github/skills/self-improving-agent/SKILL.md` | Cold copy: `.github/skills-cold/self-improving-agent/SKILL.md`; active-skill path removal is not approved. |
| 314 | C | ` D` | `.github/skills/sql-database-assistant/references/optimization_guide.md` | Cold copy: `.github/skills-cold/sql-database-assistant/references/optimization_guide.md`; active-skill path removal is not approved. |
| 315 | C | ` D` | `.github/skills/sql-database-assistant/references/orm_patterns.md` | Cold copy: `.github/skills-cold/sql-database-assistant/references/orm_patterns.md`; active-skill path removal is not approved. |
| 316 | C | ` D` | `.github/skills/sql-database-assistant/references/query_patterns.md` | Cold copy: `.github/skills-cold/sql-database-assistant/references/query_patterns.md`; active-skill path removal is not approved. |
| 317 | C | ` D` | `.github/skills/sql-database-assistant/scripts/migration_generator.py` | Cold copy: `.github/skills-cold/sql-database-assistant/scripts/migration_generator.py`; active-skill path removal is not approved. |
| 318 | C | ` D` | `.github/skills/sql-database-assistant/scripts/query_optimizer.py` | Cold copy: `.github/skills-cold/sql-database-assistant/scripts/query_optimizer.py`; active-skill path removal is not approved. |
| 319 | C | ` D` | `.github/skills/sql-database-assistant/scripts/schema_explorer.py` | Cold copy: `.github/skills-cold/sql-database-assistant/scripts/schema_explorer.py`; active-skill path removal is not approved. |
| 320 | C | ` D` | `.github/skills/sql-database-assistant/SKILL.md` | Cold copy: `.github/skills-cold/sql-database-assistant/SKILL.md`; active-skill path removal is not approved. |
| 321 | C | ` D` | `.github/skills/ux-researcher-designer/assets/research_plan_template.md` | Cold copy: `.github/skills-cold/ux-researcher-designer/assets/research_plan_template.md`; active-skill path removal is not approved. |
| 322 | C | ` D` | `.github/skills/ux-researcher-designer/references/example-personas.md` | Cold copy: `.github/skills-cold/ux-researcher-designer/references/example-personas.md`; active-skill path removal is not approved. |
| 323 | C | ` D` | `.github/skills/ux-researcher-designer/references/journey-mapping-guide.md` | Cold copy: `.github/skills-cold/ux-researcher-designer/references/journey-mapping-guide.md`; active-skill path removal is not approved. |
| 324 | C | ` D` | `.github/skills/ux-researcher-designer/references/persona-methodology.md` | Cold copy: `.github/skills-cold/ux-researcher-designer/references/persona-methodology.md`; active-skill path removal is not approved. |
| 325 | C | ` D` | `.github/skills/ux-researcher-designer/references/usability-testing-frameworks.md` | Cold copy: `.github/skills-cold/ux-researcher-designer/references/usability-testing-frameworks.md`; active-skill path removal is not approved. |
| 326 | C | ` D` | `.github/skills/ux-researcher-designer/scripts/persona_generator.py` | Cold copy: `.github/skills-cold/ux-researcher-designer/scripts/persona_generator.py`; active-skill path removal is not approved. |
| 327 | C | ` D` | `.github/skills/ux-researcher-designer/SKILL.md` | Cold copy: `.github/skills-cold/ux-researcher-designer/SKILL.md`; active-skill path removal is not approved. |
| 328 | C | ` D` | `.github/skills/weekly-review/assets/example_weekly_review.md` | Cold copy: `.github/skills-cold/weekly-review/assets/example_weekly_review.md`; active-skill path removal is not approved. |
| 329 | C | ` D` | `.github/skills/weekly-review/assets/weekly_review_checklist.md` | Cold copy: `.github/skills-cold/weekly-review/assets/weekly_review_checklist.md`; active-skill path removal is not approved. |
| 330 | C | ` D` | `.github/skills/weekly-review/references/gtd_weekly_review_canon.md` | Cold copy: `.github/skills-cold/weekly-review/references/gtd_weekly_review_canon.md`; active-skill path removal is not approved. |
| 331 | C | ` D` | `.github/skills/weekly-review/references/open_loop_psychology.md` | Cold copy: `.github/skills-cold/weekly-review/references/open_loop_psychology.md`; active-skill path removal is not approved. |
| 332 | C | ` D` | `.github/skills/weekly-review/references/review_cadence_design.md` | Cold copy: `.github/skills-cold/weekly-review/references/review_cadence_design.md`; active-skill path removal is not approved. |
| 333 | C | ` D` | `.github/skills/weekly-review/scripts/commitment_auditor.py` | Cold copy: `.github/skills-cold/weekly-review/scripts/commitment_auditor.py`; active-skill path removal is not approved. |
| 334 | C | ` D` | `.github/skills/weekly-review/scripts/open_loop_scanner.py` | Cold copy: `.github/skills-cold/weekly-review/scripts/open_loop_scanner.py`; active-skill path removal is not approved. |
| 335 | C | ` D` | `.github/skills/weekly-review/scripts/weekly_review_gate.py` | Cold copy: `.github/skills-cold/weekly-review/scripts/weekly_review_gate.py`; active-skill path removal is not approved. |
| 336 | C | ` D` | `.github/skills/weekly-review/SKILL.md` | Cold copy: `.github/skills-cold/weekly-review/SKILL.md`; active-skill path removal is not approved. |
| 337 | A | ` D` | `Architecture.jfif` | Same-name target exists in repo and Backup; image not opened or hashed. |
| 338 | A | ` D` | `docs/TimeMem-Home-Hub-Packaging.md` | Moved to `docs/working/TimeMem-Home-Hub-Packaging.md`; repo and Backup SHA-256 match. |
| 339 | A | ` D` | `docs/TimeMem-Home-Hub-Physical-Setup.md` | Moved to `docs/working/TimeMem-Home-Hub-Physical-Setup.md`; repo and Backup SHA-256 match. |
| 340 | A | ` D` | `docs/TimeMem-Install-SOP-Lock-Version.md` | Moved to `docs/working/TimeMem-Install-SOP-Lock-Version.md`; repo and Backup SHA-256 match. |
| 341 | A | ` D` | `docs/TimeMem-PRD-V10-1.md` | Moved to `docs/archive/TimeMem-PRD-V10-1.md`; repo and Backup SHA-256 match. |
| 342 | A | ` D` | `docs/TimeMem-Sprint-1-Wake-Test.md` | Moved to `docs/working/TimeMem-Sprint-1-Wake-Test.md`; repo and Backup SHA-256 match. |
| 343 | A | ` D` | `docs/原構思 IDEA.txt` | Moved to `docs/prd/原構思 IDEA.txt`; repo and Backup SHA-256 match. |
| 344 | A | ` D` | `Structure.jfif` | Same-name target exists in repo and Backup; image not opened or hashed. |

---

Audit is read-only except for creation of this requested report. Staged state was not changed.
