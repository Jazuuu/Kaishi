# Security and privacy

**Last checked:** 2026-10-09

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Lesson progress (completed lesson IDs, last lesson, percentage) | On the device (`shared_preferences`, key `user_progress`)| only that user |
| Lesson content and word list | JSON files bundled in the app | Anyone, it is public learning material |
| Questions typed to Sensei | Not saved. Kept in memory while the app is open, and sent to Google's Gemini API to get an answer | Google (the Gemini API) and the user |

## Secrets

- Values my app needs at run time: `GEMINI_API_KEY`
- Where they live locally: `assets/.env`, which is git-ignored (`.gitignore` has `.env` and `.env.*`). `.env.example` is committed.
- Where the deploy workflow gets them: the repository secret `GEMINI_API_KEY` (Settings > Secrets and variables > Actions). The workflow writes it into `assets/.env` when it builds.
- Anything my deployed web build carries that a visitor could read, and why that is acceptable: **the Gemini API key.** It is compiled into the web build, so someone who inspects the site could find it. This is not ideal. I accept it for a class demo because the key is only for this project and has no billing details beyond the free quota. I limit the damage by setting a usage limit on the key in Google AI Studio. If it is ever abused, I delete it and make a new one.
protected by rules, or nothing)_

## What protects the data on the service side

- Nothing leaves the device except the text sent to the Gemini API. There is no Firestore or Supabase, so there are no database rules to write. The key's usage limit is the only protection on the service side.

## Checklist

- [x] `.env` is in `.gitignore`, and `.env.example` is committed (checked 2026-10-11; `assets/.env` is covered by the `.env` rule)
- [ ] `git log -p | grep -i "api_key\|secret\|password\|token"` finds nothing real (not checked yet, I will run it on my real repo)
- [x] No service account file, keystore or `service_role` key in the repo (searched the project files 2026-10-11, found none)
- [x] Security rules or RLS policies: not needed, there is no backend
- [ ] No real personal data in sample data, screenshots or the video (sample data is checked, screenshots and video are not checked yet)
- [x] No course or university credentials anywhere in the project files (searched 2026-10-11; commit history not checked yet)
- [x] Anyone whose data appears in a test was asked first: nobody else's data is used

 I have not found a leaked key, but I have not searched my git history yet.
