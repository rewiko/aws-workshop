const http = require("http");
const express = require("express");
const { Sequelize, DataTypes } = require("sequelize");

const app = express();
const dbHostname = process.env.DBHostname;
const dbName = process.env.DBName || "workshopdb";
const dbUsername = process.env.DBUsername || "dbadmin";
const dbPassword = process.env.DBPassword;
const dbPort = process.env.DBPort || "3306";

const hostname = process.env.hostname || "hostname";

// create connection to database
const sequelize = new Sequelize(dbName, dbUsername, dbPassword, {
  host: dbHostname,
  dialect: "mysql",
  port: dbPort,
  pool: {
    max: 50,
    min: 5,
    acquire: 30000,
    idle: 10000,
  },
});

const User = sequelize.define(
  "User",
  {
    firstName: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    lastName: {
      type: DataTypes.STRING,
    },
  },
  {}
);

sequelize.sync({ alter: true });
console.log("All models were synchronized successfully.");

// Routes
app.get("/", function (req, res, next) {
  console.log("request on /");
  res.status(200).json({ status: "ok", provided_by: hostname });
});

app.get("/users", async function (req, res, next) {
  let users;
  try {
    users = await User.findAll();
  } catch (error) {
    console.error("Unable to truncate table user:", error);
    return res
      .status(500)
      .json({ status: "ko", message: "Unable to truncate table user" });
  }
  res.status(200).json({ provided_by: hostname, data: users });
});

app.get("/import-data", async function (req, res, next) {
  try {
    await User.truncate();
    console.log("User table truncated!");
  } catch (error) {
    console.error("Unable to truncate table user:", error);
    return res
      .status(500)
      .json({ status: "ko", message: "Unable to truncate table user" });
  }

  persons = [
    { firstname: "Tom", lastname: "Alberts" },
    { firstname: "Dominick", lastname: "Bentz" },
    { firstname: "Roger", lastname: "Johnson" },
    { firstname: "Carolina", lastname: "Schlesinger" },
    { firstname: "Gilberto", lastname: "Blevins" },
  ];

  persons.forEach(async (person) => {
    try {
      await User.create({
        firstName: person.firstname,
        lastName: person.lastname,
      });
    } catch (error) {
      console.error("Unable to create user:", error);
      return res
        .status(500)
        .json({ status: "ko", message: "Unable to create user" });
    }
  });

  res
    .status(200)
    .json({ status: "ok", message: "data imported", provided_by: hostname });
});

app.use(function (err, req, res, next) {
  console.log(err);
  res.sendStatus(500);
});

// Server
const host = process.env.HOST || "0.0.0.0";
const port = process.env.PORT || 8080;
const server = http
  .createServer(app)
  .on("close", () => console.log("closed"))
  .listen(port, host, () => {
    console.log(`listening on ${host}:${port}`);
  });

// shutdown handling
async function handleShutdown(signal) {
  console.log("starting shutdown, got %s", signal);
  console.log("waiting for inflights requests to complete");
  await delay(1000);
  if (!server.listening) process.exit(0);
  console.log("closing...");
  // closing connection to mysql
  try {
    await sequelize.close();
    console.log("Connection has been closed successfully.");
  } catch (error) {
    console.error("Unable to close the connection:", error);
  }

  server.close((err) => {
    if (err) {
      console.error(err);
      return process.exit(1);
    }
    console.log("exiting");
    process.exit(0);
  });
}

// listening on OS signal to shutdown gracefully the application
process.on("SIGINT", handleShutdown);
process.on("SIGTERM", handleShutdown);

const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
