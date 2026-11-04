const express = require("express");
const bcrypt = require("bcrypt");
const mysql = require("mysql2/promise");

const app = express();

app.use(express.json());

const db = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "yourPassword",
    database: "portfolio_website"
});

app.post("/api/register", async (req, res) => {

    const {
        firstName,
        lastName,
        username,
        email,
        password
    } = req.body;

    const passwordHash = await bcrypt.hash(password, 10);

    await db.execute(
        `INSERT INTO User
        (first_name, last_name, username, email, password_hash)
        VALUES (?, ?, ?, ?, ?)`,
        [firstName, lastName, username, email, passwordHash]
    );

    res.json({
        success: true,
        message: "Account created successfully"
    });

});

app.listen(3000, () => {
    console.log("Server running on port 3000");
});