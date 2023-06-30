import mysql.connector

#Establish a connection to MySQL server 
con = mysql.connector.connect(
    host='localhost',
    user='root',
    password='rootuser',
    database='mydb'
) 

# Create a cursor object to execute SQL queries
cursor = con.cursor()

# Execute an SQL query
cursor.execute("SELECT * FROM autombile LIMIT 50")

# Fetch all rows returned by the query
rows = cursor.fetchall()

# Process the results
for row in rows:
    print(row)

# Close the cursor and the database connection
cursor.close()
con.close()