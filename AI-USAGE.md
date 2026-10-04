# AI usage

## 1. How I used AI


### 2026-09-28 - Local Json Files

- **Tool: CHATGPT**
- **What I asked for: Asked for a local json data containing the lessons**
- **What it gave back: It provided lesson data for Hiragana, Katakana, and basic Grammar that I could use in my app.**
- **What I kept, what I changed, and why: : I kept most of the lesson content, but changed some of the examples because I felt that some were too difficult to learn or too complicated for beginners.**
- **Commit https://github.com/Jazuuu/Kaishi/commit/9e945088913b0ea6c6b53e0de43a4011bfb3d2fe**
- **Note: The commit linked above is from the old folder I originally created for the local data. I later created a new folder for the local data, but the content committed in the linked commit remains the same into the new local data folder.**


### 2026-10-02 - Lesson Service

- **Tool: CLAUDE**
- **What I asked for: Help getting the service of my app to the local JSON file containing my lesson data.**
- **What it gave back: Provided a code that loads and organizes the lesson data from the JSON file so my app can use it.**
- **What I kept, what I changed, and why: I kept the main structure as it help me to connect my local JSON data to the app and understood how the lesson data gets loaded and used by the Lessons screen.**
- **Commit:https://github.com/Jazuuu/Kaishi/commit/4de4e04af729879f5f339f7bf1fa4dea069f2dc7**

### 2026-10-03 - Gemini

- **Tool: CLAUDE**
- **What I asked for: Help and explain how to connect my app to the gemini api for the ai chat bot.**
- **What it gave back: It provided a GeminiService that connects to Gemini, sends the user's question, and returns the AI's response based on the current lesson.**
- **What I kept, what I changed, and why: I kept basic setup on how Gemini connects to my app and responds to questions. I adjusted it for Kaishi and added the current lesson so the AI can give more relevant answers.**
- **Commit:https://github.com/Jazuuu/Kaishi/commit/7af08b962f4cce9d7981fb070554f5d770723ad9**


### 2026-10-02 - AI Assistant Screen

- **Tool: CLAUDE**
- **What I asked for: Help me connect the AI Assistant screen that to my Gemini service to the chat interface.**
- **What it gave back: Connected it to the Gemini service, sends the user's questions, and displays Sensei's responses in the chat**
- **What I kept, what I changed, and why: I used the setup as a base and changed it to fit Kaishi. I added the current lesson so Gemini can give related answers.**
- **Commit:https://github.com/Jazuuu/Kaishi/commit/4bd668fb58bbc170ac943de2e9fe4bc0fe1abcd0**


### 2026-10-02 - Lesson Screen
- **Tool: CLAUDE**
- **What I asked for: Help do the Lessons screen that connects the lesson data, progress tracking, and lesson categories.**
- **What it gave back: loads lessons from the local JSON, lets the user switch between Hiragana, Katakana, and Grammar, and updates the displayed lesson based on the selected category.**
- **What I kept, what I changed, and why:  I kept the main structure it already worked with my lesson data and progress system. I also kept the dynamic lesson system so I could use one screen for different lessons instead of making a separate screen for each one.**
- **Commit:https://github.com/Jazuuu/Kaishi/commit/33a267f39fa2ad251b81363641f7951c7c62b585**

### 2026-10-02 - Home screen

- **Tool: CLAUDE**
- **What I asked for: help me connect everything needed for the Home Screen and double-check if the code was working correctly with the other parts of my app.**
- **What it gave back:connects the lesson data, progress tracking, Word of the Day, progress card, and navigation.**
- **What I kept, what I changed, and why:I kept most of what it gave me because it already connected the features I needed. I mainly changed and adjusted some parts to match my design and how I wanted the Home Screen to work.**
- **Commit:https://github.com/Jazuuu/Kaishi/commit/33a267f39fa2ad251b81363641f7951c7c62b585**

## 2. Where the AI got it wrong

### Case 1 - Gemini Version

- **What it gave me: used the gemini-1.5-flash model.**  
- **What was wrong with it: That model is outdated and no longer supported by the Gemini API, so requests to it failed with an error.** 
- **What I did instead: I updated the model name to the latest version, gemini-3.8-flash.**
- **Commit:** https://github.com/Jazuuu/Kaishi/commit/cc91fa4270eababb5f007ef62d3b69501a077901

## 3. Who wrote what

### Written by me

- **File:lib/theme/app_spacing and lib/theme/app_theme**
- **Commit: https://github.com/Jazuuu/Kaishi/commit/240934b7206d614edcc6a05536ebb5fc309e3ad6 and https://github.com/Jazuuu/Kaishi/commit/23793ff437b0aafd50ca934cc08c12c64cb328dc**
- **What it does and why it is built this way:This is used as spacing and theme values for the app. Its just to organize these styles in Flutter and implemented them so I can keep the spacing, colors, and text styles consistent across all the screens instead of setting them separately each time**

- **File:lib/sevices/progress_service**
- **Commit: https://github.com/Jazuuu/Kaishi/commit/572cddf9a2e3787d79208a700101291c8687bf7a**
- **What it does and why it is built this way: It saves and loads the user's lesson progress on their device. I researched how to use SharedPreferences for this project and implemented it so the app can save progress without needing accounts or a cloud database.**

- **File:lib/widgets/lesson_card**
- **Commit: https://github.com/Jazuuu/Kaishi/commit/217287b22cde1b4bc03f628b218bd331627f5063**
- **What it does and why it is built this way: It displays the lesson title, description, characters, and vocabulary in one reusable card. I researched how to make one layout work for different lessons then used constructor parameters so the content can change without creating a separate card for each lesson**

- **File:lib/widgets/app_header**
- **Commit: https://github.com/Jazuuu/Kaishi/commit/775076738b204159b5be53f18c05aa17e18f4936**
- **What it does and why it is built this way: It is a header for each screen that shows the screen title and an icon. I made it reusable so I can use it across all the screens while changing the title and icon depending on the screen. this was a last minute addition as without the header, the screens felt like they were missing something on them.**

### The AI-written part I understand best

- **File:lib/services/gemini_service**
- **Commit:https://github.com/Jazuuu/Kaishi/commit/7af08b962f4cce9d7981fb070554f5d770723ad9**
- **What it does and why we kept it: Gemini service connects Kaishi to the Gemini AI so the AI chat assistant can answer questions about Japanese lessons. It also uses the current lesson as context so that it answers based on the lesson the user is currently studying.**

- **File:lib/screens/ai_assistant_screen**
- **Commit:https://github.com/Jazuuu/Kaishi/commit/4bd668fb58bbc170ac943de2e9fe4bc0fe1abcd0**
- **What it does and why we kept it:  Handles the chat screen where users can ask AI chat questions about their current lesson. Connects the chat UI to Gemini and keeps the conversation inside the app**
