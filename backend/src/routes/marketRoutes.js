const express = require("express");
const { getMarketStats } = require("../services/coinGeckoService");

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const marketStats = await getMarketStats();

    res.json(marketStats);
  } catch (error) {
    console.error("Market Stats API Error:", error.message);

    res.status(500).json({
      message: "Failed to fetch market statistics",
    });
  }
});

module.exports = router;