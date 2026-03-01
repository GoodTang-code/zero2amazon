# STEP 00 — PROJECT SETUP

## Objective
Prepare the project structure and establish the **single source of truth** for the novel.

This step ensures the agent has a clean workspace and a stable foundation before any creative work begins.

---

## Task 1 — Create Folder Structure

Create the following folders if they do not exist:

00_process/
01_story_bible/
02_premise/
03_characters/
04_world_rules/
05_plot/
06_chapter_blueprints/
07_manuscript/
99_exports/

Do NOT delete existing content.

---

## Task 2 — Initialize Story Bible

Create the following files inside `01_story_bible/`:

story_overview.md  
mood_tone_style.md  
writing_rules.md  
glossary.md  
timeline_master.md  

### Purpose

**story_overview.md**
→ high-level summary & direction

**mood_tone_style.md**
→ emotional atmosphere & stylistic guidance

**writing_rules.md**
→ readability, pacing, stylistic constraints

**glossary.md**
→ terminology & naming consistency

**timeline_master.md**
→ chronological continuity reference

---

## Task 3 — Initialize Process Logs

Create these files if missing:

00_process/decision_log.md  
00_process/scoring_log.md  

### Purpose

decision_log.md
→ record major creative decisions

scoring_log.md
→ record evaluation results & quality checks

---

## Task 4 — Define Story Bible Authority

Add the following rule to `01_story_bible/story_overview.md`:

> This folder is the SINGLE SOURCE OF TRUTH for the novel.  
> All writing must remain consistent with its contents.  
> If conflicts occur, update the bible before revising drafts.

---

## Task 5 — Create Master Progress Checklist

Create a progress tracking file:

00_process/project_progress.md

This file will be used throughout the entire project lifecycle.

It tracks:
- completed stages
- current step
- revision status
- overall progress
- word count milestones (synced from `00_process/word_count_log.md`)

---

### Initialize the file with the following structure:

# Project Progress Tracker

## Current Stage
Setup

## Overall Progress
0%

---

## Stage Status

### Setup
- [ ] Folder structure created
- [ ] Story bible initialized
- [ ] Process logs created
- [ ] Authority rule inserted
- [ ] Progress tracker created

### Premise Engine
- [ ] 100 what-if seeds generated
- [ ] top premises selected
- [ ] premise stress tested
- [ ] promise of premise finalized

### Story Bible Development
- [ ] mood & tone defined
- [ ] writing rules defined
- [ ] glossary initialized
- [ ] timeline master created

### Character Architecture
- [ ] main characters created
- [ ] supporting characters created
- [ ] relationship map completed
- [ ] character arcs defined

### World & Rules
- [ ] world overview completed
- [ ] system rules defined
- [ ] constraints & costs defined
- [ ] loopholes stress-tested

### Plot Architecture
- [ ] core plot arc completed
- [ ] escalation ladder defined
- [ ] twist bank created
- [ ] chapter blueprint completed

### Drafting
- [ ] draft structure ready
- [ ] act I written
- [ ] act II written
- [ ] act III written
- [ ] full draft completed
- [ ] word count updated after each drafting session

### Revision
- [ ] structural revision
- [ ] pacing revision
- [ ] consistency pass
- [ ] tone & style pass
- [ ] final polish
- [ ] word count delta updated after each revision pass

### Production
- [ ] manuscript formatted
- [ ] EPUB generated
- [ ] metadata prepared
- [ ] cover ready
- [ ] Amazon checklist completed

---

## Revision Log
(empty)

---

## Notes
(empty)

---

## Task 6 — Create Word Count Tracker

Create this file if missing:

00_process/word_count_log.md

### Purpose

Track writing throughput and progress toward the 80,000-word target.

### Initialize the file with the following structure:

# Word Count Log

## Target
80,000 words

## Current Total
0

## Entries
| Date | Stage | File/Section | Words Added | Words Removed | Net | Running Total | Notes |
|---|---|---|---:|---:|---:|---:|---|

---

### Update Rules

The agent must update `00_process/project_progress.md` after completing any stage.

- Mark completed tasks
- Update current stage
- Update overall progress %
- Add revision notes if required
- Sync progress status with latest `00_process/word_count_log.md` totals

The agent must update `00_process/word_count_log.md` after each writing/revision session in `07_manuscript/`.

`00_process/project_progress.md` serves as the master progress dashboard.

---

## Validation Checklist

Agent must verify:

- Folder structure exists
- Story bible files created
- Process logs created
- Word count tracker created
- No existing files overwritten
- Authority rule inserted

---

## Output Format (Required)

After completion, output:

[STEP COMPLETED]  
Step: Setup  
Status: PASS | REVISION REQUIRED  

Files created/updated:
- …

Issues:
- …

Next step:
- Premise Engine (Step 01)
