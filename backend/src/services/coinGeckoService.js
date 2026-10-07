const axios = require("axios");

const coinGeckoApi = axios.create({
  baseURL: "https://api.coingecko.com/api/v3",
  headers: {
    "x-cg-demo-api-key": process.env.COINGECKO_API_KEY,
  },
});

const getCoins = async () => {
  const response = await coinGeckoApi.get("/coins/markets", {
    params: {
      vs_currency: "usd",
      order: "market_cap_desc",
      per_page: 20,
      page: 1,
      sparkline: false,
    },
  });

  return response.data;
};


const getCoinDetails = async (coinId) => {
  const response = await coinGeckoApi.get(`/coins/${coinId}`, {
    params: {
      localization: false,
      tickers: false,
      market_data: true,
      community_data: false,
      developer_data: false,
      sparkline: false,
    },
  });

  return response.data;
};

const getCoinChart = async (coinId, days = 7) => {
  const response = await coinGeckoApi.get(
    `/coins/${coinId}/market_chart`,
    {
      params: {
        vs_currency: "usd",
        days: days,
        interval: "hourly",
      },
    }
  );

  return response.data;
};

const getMarketStats = async () => {
  const response = await coinGeckoApi.get("/global");

  return response.data.data;
};

module.exports = {
  getCoins,
  getCoinDetails,
  getCoinChart,
  getMarketStats,
};