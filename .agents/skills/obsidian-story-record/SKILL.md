---
name: obsidian-story-record
description: "Use after major TimeMem decisions, Skill or file moves, archives, renames, document changes, or M0 status changes to write a readable, evidence-based daily Obsidian story with clear approval scope and named files."
---

# Obsidian Story Record

After a major TimeMem decision or project change, maintain one concise daily story note using evidence that persists across sessions. Each update replaces today's summary with a deduplicated rewrite; it must not append another running log or make the file grow over the day. This is a narrative record, not a product database or a place to make decisions.

## Procedure

1. Determine today's local date and the relevant project repository and Vault roots. For TimeMem, use repository `C:\Project\TimeMem` and Vault `C:\Project\Obsidian-Hub\TimeMem`.
2. Locate `C:\Project\Obsidian-Hub\TimeMem\TimeMem-Story`. Create this folder if it does not exist. Before editing, read today's existing Markdown note, identified by its `YYYY-MM-DD-` filename prefix.
3. Check cross-session file evidence in the project repository:
   - Run `git status --short` from the repository root and identify staged, unstaged, and untracked paths.
   - Run `git log --since="<local-day-start>" --until="<next-day-start>" --name-status --format=` with local-time boundaries, so files changed in today's commits are included as well as uncommitted work.
   - For non-secret paths, establish which changes are from today using the status, commit records, and available timestamps. Inspect relevant diffs or changed files only when needed to understand the change. If a path's date or purpose is unclear, do not claim it as today's work.
   - For `.env`, `.env.docker`, `Secrets-Backup`, and any file known or suspected to contain secrets, inspect filenames/status only. Never open, read, or diff those files; do not include secret values.
4. Check the relevant project Vault for files created today. For TimeMem, inspect file metadata under `C:\Project\Obsidian-Hub\TimeMem`; identify today's new files and inspect only relevant project materials needed to understand their changes. For `.env`, `.env.docker`, `Secrets-Backup`, and any file known or suspected to contain secrets, inspect filenames/metadata only; never open, read, or diff them. Do not alter other Vault files or record secrets.
5. Reconcile today's story with the repository status, today's commit file list, today's new Vault files, and non-secret project files changed during this run (excluding the story note itself). These are the only evidence sources for story claims. Use the existing story only to identify and merge duplicates; it is not evidence and must not verify or perpetuate a claim by itself. Do not infer events, decisions, or completed work from chat alone. Record only major events: decisions, Skills opened, created, edited, moved, archived, or renamed, substantive document changes, and M0 status. Skill moves, archiving, and renames are major events; record them with the Skill/file names and destinations. Do not record minutiae such as file searches, routine command runs, or inspection steps.
6. Before drafting, check the allowed evidence sources for today's confirmed decisions, Skill changes, and changes to `docs/DECISIONS.md`, `docs/ARCHITECTURE.md`, or `docs/M0-READY.md`. If there is no confirmed decision, no Skill change, and none of those three documents changed today, write `今日無大事`; do not force the 200-300-character length or invent events to fill space.
7. If today's note exists, consolidate overlapping or repeated information and rewrite the day's summary in place; do not append. If none exists, create one named `YYYY-MM-DD-短標題.md`. Keep the filename short and make the frontmatter `title` match the filename stem exactly, excluding `.md`. If the existing title and filename differ, rename the same daily note and update its title; never create a duplicate.
8. Use exactly these three sections, in this order:

   ```markdown
   ## 今日總結
   - 決定：...（說清決定內容，補一點必要背景）
   - 結果：...（說清具體結果，補一點必要背景）

   ## 今日做咗咩
   - [File/Skill name]: [What specifically changed.]

   ## 下一步
   - [The next meaningful action, or state that no next step is confirmed.]
   ```

   Keep exactly three sections in both cases, with a blank line before and after each heading. When `今日無大事` applies, use that phrase in the first section, leave the event list empty, and state there is no confirmed next step unless evidence shows one. Otherwise, write the first section as point form, not a prose paragraph. Use one bullet per major decision or result; each point must clearly state the decision or result and include a little necessary context, not just a bare label. When describing approval, name exactly what was approved; for example, write `批咗 CR-002，M0 仲未批`, not a bare `已批准` that could imply M0 approval. Do not repeat equivalent statuses or statements in another section; for example, do not separately say both `M0 gate 保持 Draft` and `M0 未獲批准`. The summary normally contains 200-300 Chinese characters; if there are more than three major items, it may extend to 350 characters. Do not delete a major item just to stay within 300 characters; shorten explanations first. Do not impose a sentence count. The summary covers only high-level decisions and outcomes; do not put next steps there.

   The second section is the detailed event list. For each major event, name the specific changed file or Skill using only its short basename or Skill slug, such as `DECISIONS.md` or `joe-keywords`; never put an absolute or full repository path in the story. State what changed, not only a count. For a bulk Skill move, archive, or rename, include the names and destination/status, grouping related names into short bullets as needed. Give each distinct file/Skill change its own concise bullet. Keep each rendered bullet to at most two lines; split a long point into shorter points without repeating its meaning. Use Chinese commas and colons consistently, end sentences with Chinese full stops, and keep English terms and capitalization consistent (for example `M0`, `PWA`, `Tailnet`, `Skill`, `Draft`, `Approved`, `Critical`, and `Major`). These details must complement, not copy, the summary. Put the next step only in the third section. Keep all sections simple and clear; merge repeated events instead of repeating them, and rewrite the full daily summary so updates do not make the file progressively longer. Do not add extra sections.
9. Change only today's story note; leave all other Vault notes untouched. Do not include passwords, API keys, `.env` contents, or other secrets. Do not write product code, run migrations, or commit changes as part of this record task.
10. Never describe M0 as approved unless Joe's explicit final approval is confirmed. Clearing TBDs, passing checks, or completing reviews alone is not approval.
11. Verify the note has exactly the three required sections and its frontmatter title matches the filename stem. If the no-major-event condition applies, confirm the first section says `今日無大事`, no filler was added, and the length rule was waived. Otherwise, confirm the first section is point form with one adequately descriptive major decision or result per bullet, normally 200-300 characters and up to 350 when there are more than three major items; do not omit a major item merely to meet 300. Confirm approval wording names the approved object and does not imply M0 approval. Check that meanings and statuses are not repeated. In the second section, verify major Skill moves, archives, and renames are recorded; each major changed file or Skill is named and its change is described, rather than represented only by a count; paths are short; punctuation is consistent; and no bullet exceeds two rendered lines. The third section contains the next step only. Confirm every claim is supported by today's `git status`, today's `git log`, today's new Vault files, or relevant non-secret project files changed during this run. The existing story may be used only for deduplication, never as evidence. Confirm secret files were not opened or diffed and no other Vault note was changed.
