const axios = require("axios");
axios
  .get(
    "https://ipgeolocation.abstractapi.com/v1?api_key=286e580a464848a5ab14d335d349a5f2"
  )
  .then((response) => {
    console.log(response.data);
  })
  .catch((error) => {
    console.log(error);
  });
