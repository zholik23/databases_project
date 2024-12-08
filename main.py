from flask import Flask, render_template, request, jsonify, redirect, url_for, flash, session
import psycopg2
import cv2
import numpy as np
import base64
from ultralytics import YOLO
from functools import lru_cache
from werkzeug.security import generate_password_hash, check_password_hash


app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Replace with a strong, random key

# Load YOLO model
model = YOLO('best.pt')

# Database connection parameters
DB_HOST = 'localhost'
DB_PORT = '5432'
DB_NAME = 'project'
DB_USER = 'admin'
DB_PASSWORD = 'admin'

def get_db_connection():
    """Establish a connection to the database."""
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

# Home route
@app.route('/')
def index():
    """Render the main page."""
    logged_in = 'userid' in session
    return render_template('main.html', logged_in=logged_in)
@app.route('/home')
def home():
    logged_in = 'userid' in session
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT postid, title, authorid, content, createdat FROM blogpost ORDER BY createdat DESC')
        rows = cursor.fetchall()
        cursor.close()
        conn.close()

        # Convert rows to a list of dictionaries
        blogs = [
            {
                'postid': row[0],
                'title': row[1],
                'authorid': row[2],
                'content': row[3],
                'createdat': row[4].strftime('%Y-%m-%d %H:%M:%S')  # Format datetime as a string
            }
            for row in rows
        ]

        return render_template('home.html', blogs=blogs, logged_in=logged_in)  # Pass logged_in here
    except Exception as e:
        return f"Error: {str(e)}"



@app.route('/add', methods=['GET', 'POST'])
def add_blog():
    """Add a new blog post only if the user is logged in."""
    # Ensure the user is logged in
    if 'userid' not in session:
        flash('You must be logged in to add a blog.', 'danger')
        return redirect(url_for('login'))  # Redirect to the login page if not logged in

    if request.method == 'POST':
        title = request.form['title']
        content = request.form['content']
        authorid = session['userid']  # Use the logged-in user's ID as the author

        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            # Insert the new blog post with the authorid
            cursor.execute(
                'INSERT INTO blogpost (title, content, authorid) VALUES (%s, %s, %s)',
                (title, content, authorid)
            )
            conn.commit()
            cursor.close()
            conn.close()
            flash('Blog added successfully!', 'success')
            return redirect(url_for('home'))  # Redirect back to the home page after adding a blog
        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')

    return render_template('add.html')  # Render the blog addition form if GET request

# Route: API to fetch all blog posts
@app.route('/api/blogs')
def get_blogs():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM blogpost ORDER BY created_at DESC')
        blogs = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(blogs)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# AI Picker route
@app.route('/ai-picker')
def ai_picker():
    """Render the AI Picker page."""
    return render_template('index.html')

@app.route('/api/posts', methods=['GET'])
def get_posts():
    """Fetch all blog posts."""
    try:
        connection = get_db_connection()
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT postid, title, authorid, content, createdat 
                FROM blogpost 
                ORDER BY createdat DESC
            """)
            posts = cursor.fetchall()
        connection.close()
        return jsonify(posts)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Login route

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Render login page and handle login logic."""
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        try:
            connection = get_db_connection()
            with connection.cursor() as cursor:
                cursor.execute(
                    'SELECT userid, username, passwordhash, role FROM "User" WHERE username = %s',
                    (username,)
                )
                user = cursor.fetchone()
            connection.close()

            # Check if user exists and password matches
            if user and user[2] == password:  # Use check_password_hash for secure password verification
                session['userid'] = user[0]
                session['username'] = user[1]
                session['role'] = user[3]  # Store user role
                flash('Login successful!', 'success')
                return redirect(url_for('home'))  # Redirect to home after login
            else:
                flash('Invalid username or password.', 'danger')
        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')

    return render_template('login.html')


@app.route('/logout')
def logout():
    """Handle user logout."""
    session.clear()
    flash('You have been logged out.', 'success')
    return redirect(url_for('index'))

# Frame processing logic
def process_frame(image_data):
    """Decode image, process with YOLO, and detect emotion."""
    img_data = base64.b64decode(image_data.split(",")[1])
    np_arr = np.frombuffer(img_data, np.uint8)
    frame = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

    # Run YOLO model
    results = model.predict(frame, imgsz=320, conf=0.5)
    detected_emotion = None
    highest_confidence = 0

    for r in results:
        frame = r.plot(conf=False)
        for box in r.boxes:
            conf = box.conf
            cls = box.cls
            label = r.names[int(cls)]
            if conf > highest_confidence:
                detected_emotion = label
                highest_confidence = conf

    _, buffer = cv2.imencode('.jpg', frame)
    processed_frame = base64.b64encode(buffer).decode('utf-8')
    return processed_frame, detected_emotion

@lru_cache(maxsize=128)
def get_recommendations_from_db(emotion):
    """Fetch recommendations from the database based on emotion."""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        # Fetch snacks for the mood
        snack_query = """
        SELECT DISTINCT snack.name AS snack, snack.photo AS SnackPhoto
        FROM mood
        LEFT JOIN snack ON mood.moodid = snack.moodid
        WHERE mood.moodname = %s;
        """
        cursor.execute(snack_query, (emotion,))
        snacks = cursor.fetchall()

        # Fetch drinks for the mood
        drink_query = """
        SELECT DISTINCT drink.name AS drink, drink.photo AS DrinkPhoto
        FROM mood
        LEFT JOIN drink ON mood.moodid = drink.moodid
        WHERE mood.moodname = %s;
        """
        cursor.execute(drink_query, (emotion,))
        drinks = cursor.fetchall()

        # Prepare recommendations
        recommendations = []
        seen_snacks = set()
        used_drinks = set()

        snack_iterator = iter(snacks)
        drink_iterator = iter(drinks)

        try:
            while True:
                snack = next(snack_iterator)
                if snack[0] in seen_snacks:
                    continue
                seen_snacks.add(snack[0])

                # Try to get a unique drink
                try:
                    drink = next(drink_iterator)
                    while drink[0] in used_drinks:
                        drink = next(drink_iterator)
                    used_drinks.add(drink[0])

                    # Pair snack with the drink
                    recommendations.append({
                        "snack": snack[0],
                        "snackPhoto": snack[1],
                        "drink": drink[0],
                        "drinkPhoto": drink[1]
                    })
                except StopIteration:
                    # If no more unique drinks are available, just add the snack
                    recommendations.append({
                        "snack": snack[0],
                        "snackPhoto": snack[1],
                        "drink": None,
                        "drinkPhoto": None
                    })
        except StopIteration:
            pass

        cursor.close()
        connection.close()
        return recommendations
    except Exception as e:
        print("Error fetching recommendations from database:", e)
        return []

recommendations_cache = {}

@app.route('/sign-up', methods=['GET', 'POST'])
def sign_up():
    """Render the sign-up page and handle registration logic."""
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        if password != confirm_password:
            flash('Passwords do not match.', 'danger')
            return render_template('sign_up.html')

        try:
            connection = get_db_connection()
            with connection.cursor() as cursor:
                # Check if the username already exists
                cursor.execute(
                    'SELECT userid FROM "User" WHERE username = %s', (username,)
                )
                existing_user = cursor.fetchone()
                if existing_user:
                    flash('Username already exists.', 'danger')
                    return render_template('sign_up.html')

                # Insert new user into the database with a hashed password and default role
                hashed_password = generate_password_hash(password)
                cursor.execute(
                    'INSERT INTO "User" (username, passwordhash, role) VALUES (%s, %s, %s) RETURNING userid',
                    (username, hashed_password, 'Community Member')  # Default role
                )
                user_id = cursor.fetchone()[0]
            connection.commit()
            connection.close()

            flash('Sign up successful! You can now log in.', 'success')
            return redirect(url_for('login'))

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')

    return render_template('sign_up.html')

@app.route('/api/popularcombinations')
def get_popular_combinations():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # SQL query to fetch the popular combinations along with snack and drink names
        cursor.execute(''' 
            SELECT 
                pc.combinationid, 
                s.name AS snack_name, 
                d.name AS drink_name, 
                pc.popularitycount 
            FROM 
                popularcombinations pc
            JOIN snack s ON pc.snackid = s.snackid
            JOIN drink d ON pc.drinkid = d.drinkid
            ORDER BY pc.popularitycount DESC
        ''')

        # Fetch all combinations
        combinations = cursor.fetchall()

        # Close the connection
        cursor.close()
        conn.close()
        # Return the combinations in JSON format
        return jsonify(combinations)

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/process-frame', methods=['POST'])
def process_frame_endpoint():
    """Handle incoming frames, process them with YOLO, and provide recommendations."""
    try:
        data = request.json
        frame = data.get('frame')

        if not frame:
            return jsonify({"error": "No frame provided"}), 400

        processed_frame, detected_emotion = process_frame(frame)

        if detected_emotion not in recommendations_cache:
            recommendations = get_recommendations_from_db(detected_emotion)
            recommendations_cache[detected_emotion] = recommendations
        else:
            recommendations = recommendations_cache[detected_emotion]

        return jsonify({
            "processed_frame": f"data:image/jpeg;base64,{processed_frame}",
            "detected_emotion": detected_emotion,
            "recommendations": recommendations
        })
    except Exception as e:
        print("Error processing frame:", e)
        return jsonify({"error": str(e)}), 500

@app.route('/edit/<int:postid>', methods=['GET', 'POST'])
def edit_blog(postid):
    """Edit an existing blog post."""
    if 'userid' not in session:
        flash('You must be logged in to edit a blog.', 'danger')
        return redirect(url_for('login'))

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT postid, title, content FROM blogpost WHERE postid = %s AND authorid = %s', (postid, session['userid']))
        blog = cursor.fetchone()

        if not blog:
            flash('You are not authorized to edit this blog post.', 'danger')
            return redirect(url_for('home'))

        if request.method == 'POST':
            title = request.form['title']
            content = request.form['content']

            cursor.execute('UPDATE blogpost SET title = %s, content = %s WHERE postid = %s', (title, content, postid))
            conn.commit()
            flash('Blog updated successfully!', 'success')
            return redirect(url_for('home'))

        cursor.close()
        conn.close()

        return render_template('edit_blog.html', blog=blog)

    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return redirect(url_for('home'))

@app.route('/delete/<int:postid>', methods=['GET', 'POST'])
def delete_blog(postid):
    """Delete a blog post."""
    if 'userid' not in session:
        flash('You must be logged in to delete a blog.', 'danger')
        return redirect(url_for('login'))

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT postid, authorid FROM blogpost WHERE postid = %s', (postid,))
        blog = cursor.fetchone()

        if not blog or blog[1] != session['userid']:
            flash('You are not authorized to delete this blog post.', 'danger')
            return redirect(url_for('home'))

        cursor.execute('DELETE FROM blogpost WHERE postid = %s', (postid,))
        conn.commit()
        flash('Blog deleted successfully!', 'success')

        cursor.close()
        conn.close()

        return redirect(url_for('home'))

    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return redirect(url_for('home'))



if __name__ == '__main__':
    app.run(debug=True)
