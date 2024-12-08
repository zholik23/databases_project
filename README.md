# 🎯 Project Overview

An AI-powered blog platform where users can create, view, and manage blog posts. The application leverages emotion detection using the YOLO model to provide personalized snack and drink recommendations based on the user's detected emotion. It features user authentication, blog management, and a recommendation engine.

---

## 🛠 Features

- **User Authentication**: Sign up, log in, and log out functionality.
- **Blog Management**: Create, edit, and delete blog posts.
- **Emotion Detection**: AI-driven emotion detection from images using the YOLO model.
- **Personalized Recommendations**: Get personalized snack and drink suggestions based on detected emotions.
- **Dynamic Content**: Blog posts are dynamically fetched and displayed from the database.

---

## 🗂 Technologies Used

- **Backend**: Python, Flask
- **Database**: PostgreSQL
- **AI Model**: YOLO (via the Ultralytics library)
- **Frontend**: HTML, CSS, JavaScript (Flask templating engine)

### Libraries:
- **Flask**: Lightweight web framework.
- **psycopg2**: PostgreSQL adapter for Python.
- **cv2**: OpenCV for image processing.
- **ultralytics**: YOLO model for emotion detection.
- **Werkzeug**: For secure password hashing and management.

---

## 🧑‍🤝‍🧑 User Roles

- **Admin**: Full access to all features including user management and blog post administration.
- **Community Member**: Can view, create, edit, and delete their own blog posts.

---

## 🌐 API Endpoints

- **`/api/posts`**: Fetch all blog posts.
- **`/api/popularcombinations`**: Fetch popular snack and drink combinations.
- **`/process-frame`**: Handle image frames for emotion detection and personalized recommendations.

---
