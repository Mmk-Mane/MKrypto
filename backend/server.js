const express = require("express");
const cors = require("cors");
require("dotenv").config();

const coinRoutes = require("./src/routes/coinRoutes");
const marketRoutes = require("./src/routes/marketRoutes");

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    message: "MKrypto Backend is running",
  });
});

app.use("/api/coins", coinRoutes);
app.use("/api/market", marketRoutes);

app.listen(PORT, () => {
  console.log(`MKrypto Backend running on http://localhost:${PORT}`);
});