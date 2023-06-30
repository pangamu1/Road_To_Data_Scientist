import mysql.connector

try:
    # Establish a connection to the MySQL server
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='rootuser',
        database='mydb'
    )

    if conn.is_connected():
        print("Connection established successfully.")
        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        # Execute an SQL query
        cursor.execute("SELECT * FROM automobile LIMIT 10")

        # Fetch all rows returned by the query
        rows = cursor.fetchall()

        # Process the results
        for row in rows:
            print(row)

        # Close the cursor and the database connection
        cursor.close()
        conn.close()

except mysql.connector.Error as error:
    print("Error connecting to MySQL:", error)