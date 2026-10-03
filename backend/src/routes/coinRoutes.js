const express = require("express");
const {
  getCoins,
  getCoinDetails,
  getCoinChart,
} = require("../services/coinGeckoService");

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const coins = await getCoins();

    res.json(coins);
  } catch (error) {
    console.error("CoinGecko API Error:", error.message);

    res.status(500).json({
      message: "Failed to fetch coin data",
    });
  }
});

router.get("/:id/chart", async (req, res) => {
  try {
    const chart = await getCoinChart(req.params.id);

    res.json(chart);
  } catch (error) {
    console.error("Coin Chart API Error:", error.message);

    res.status(500).json({
      message: "Failed to fetch coin chart data",
    });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const coin = await getCoinDetails(req.params.id);

    res.json(coin);
  } catch (error) {
    console.error("Coin Details API Error:", error.message);

    res.status(500).json({
      message: "Failed to fetch coin details",
    });
  }
});



module.exports = router;