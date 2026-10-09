# Kaishi

## The problem, in one sentence
Beginners learning Japanese have to jump between websites, videos, translators and AI chatbots, so Kaishi puts organized lessons and an AI helper in one app.

## Who it is for
Beginners with little or no Japanese, mostly students and anime or manga fans. They want one place to study instead of many tabs.

## Core features
| # | Feature | What happens |
|---|---|---|
| 1 | Structured lessons | Hiragana, Katakana and basic Grammar, switched with tabs. The content is read from local JSON files. |
| 2 | AI helper | the user types a question about the lesson and gets a simple explanation from Gemini, without leaving the app. |
| 3 | Progress tracking | the app remembers which lessons are done and shows the percentage on the Home screen. |

Screens: Home, Lessons, Sensei (with a bottom navigation bar).
Extras (stretch goals): Word of the Day

## Out of scope, and why
- User accounts and logging in: progress stays on one device, so there is nothing to sign in to.
- Syncing progress between devices:** this would need a server, which is too much for the time we have.
- Saving chat history: chats are kept only while the app is open, to keep storage simple.
- Saving favorite words: it is a stretch goal, so it only gets built if time is left.

## Data the app remembers, and where it is saved
| Data | What is in it | Where it is saved |
| --- | --- | --- |
| Lesson content | Lesson titles, characters, vocabulary, example sentences | Local JSON files inside the project |
| Word list (backup) | A short list of Japanese words | Local JSON file inside the project |
| Progress | Completed lesson IDs, last lesson, percentage | `shared_preferences`, under the key `user_progress` |
| Current chat with Sensei | Questions and answers | Memory only, gone when the app closes |

## Risks
  - The Gemini connection can fail: the key may be missing, the internet may be off, or the service may be down. The app shows "Sensei can't respond right now" instead of crashing.

## Changes since the last version
- 10/02/26: Changed the Gemini model from `gemini-1.5-flash` to `gemini-3.8-flash`, because Google stopped serving the old one and Sensei returned "model not found".
- 10/02/26: Added a Back button on lessons, so users can review a finished lesson.
- 10/02/26: Added a reusable header to the Home and Lesson screens.
