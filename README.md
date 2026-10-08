<!--
  This is your project's front page. Replace every placeholder below.
  It is the first thing your instructor and any future employer will read, and
  the live link in it is how your project gets opened for grading.

  New here? Read START-HERE.md first. Delete this comment when you are done.
-->

# Kaishi

> Kaishi is a beginner-friendly Japanese learning app for anyone interested in learning the basics of Japanese.

**Live demo:** https://Jazuuu.github.io/Kaishi/

**Demo video:** `docs/demo.mp4`

**Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University

**Author:** Jazuuu

This repository lives in the author's own GitHub account and is public on
purpose. There is no `student.json` here and there should not be one: see
`docs/06-security-and-privacy.md` for what a public repo means for secrets and
personal data.

---

## Screenshots

Put two or three real screenshots at phone size in `docs/assets/`, then replace
this paragraph with them:

```markdown
| Home | Detail | Add |
| --- | --- | --- |
| ![Home](docs/assets/screen-home.png) | ![Detail](docs/assets/screen-detail.png) | ![Add](docs/assets/screen-add.png) |
```

A repo without screenshots reads as abandoned, whatever the code says.

## What it does

Three to five bullets. What can a user actually do?

- Learn Japanese basics through Hiragana, Katakana, and Grammar lessons.
- Ask Sensei, the AI assistant, questions about your lessons.
- Complete lessons, track your progress, and go back to restudy earlier lessons.

## Built with

| | |
| --- | --- |
| Framework | Flutter (Dart) |
| State | `setState` |
| Storage | `shared_preferences` (progress saved on the device) |
| Other packages | `google_generative_ai` (talks to Gemini) |

## Running it yourself

```bash
flutter pub get
cp assets/.env
flutter run -d web-server --web-port 8080
```

Then open http://localhost:8080. Requires Flutter (run `flutter --version` and
put yours here).

### Environment variables

TThis project reads its configuration from `assets/.env`, which is **not** in the
repository. Copy `.env.example` to `assets/.env`, fill in your own value, and never commit the result.

| Variable | What it is | Where to get one |
| --- | --- | --- |
|  `GEMINI_API_KEY` | lets the app call Gemini for AI Chat | Google AI Studio: https://aistudio.google.com/app/apikey | |

## Privacy and secrets

Required section. Two or three honest sentences:

- Kaishi does not require an account and does not collect personal data. Your lesson progress is saved only on your device
- The Gemini API key is stored locally in the .env file and is not committed to the repository or shown publicly.
- Kaishi does not use a database, and all sample lessons and word lists are made-up learning content.

## Project documentation

| Document | |
| --- | --- |
| [Proposal](docs/01-proposal.md) | the problem, the users, the scope |
| [Mockup and wireframes](docs/02-mockup.md) | what it looks like, and the screen flow |
| [Design system](docs/03-design-system.md) | colors, type, spacing, components |
| [Weekly reports](docs/04-weekly-reports.md) | what happened each week |
| [Demo video](docs/05-demo-video.md) | the recording and what it shows |
| [Start here](START-HERE.md) | how this repo works (delete once you have read it) |
| [Security and privacy](docs/06-security-and-privacy.md) | the checklist, filled in |

## Status and what is next

Be honest. What works, what is half done, what you would build next. An honest
"known issues" section reads better than a claim the reader disproves in thirty
seconds.

## Credits

- Packages: see `pubspec.yaml`
- Assets, icons, 3D models, sounds: name the author and the licence for each
- People who helped, and how

## AI use

If you used AI while building this, say so here. Honest disclosure is the
standard in this course and increasingly outside it, and reporting heavy use
accurately costs you nothing.

This section is the last 10 points of the finals badge, and it wants three
things:

![Built with AI assistance](https://img.shields.io/badge/built%20with-AI%20assistance-0b5fff)

- the badge above, or one you like better
- a line naming which assistant you used and how much of the work it touched
- a link to [AI-USAGE.md](AI-USAGE.md), where the full account lives

Keep the detail in `AI-USAGE.md` rather than here. This section is the summary a
visitor reads; that file is the record the badge is graded from.

## Licence

MIT, see [LICENSE](LICENSE). Change it if you want different terms.
