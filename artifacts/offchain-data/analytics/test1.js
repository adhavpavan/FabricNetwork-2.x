const axios = require("axios");
// const url = "https://phpstack-917741-3185561.cloudwaysapps.com/1st.php";


// var axios = require('axios');
var FormData = require('form-data');
// var data = new FormData();
// data.append('Username', 's');
// data.append('Password', 's');
// data.append('Mobile No', '121212121212121212');

// var config = {
//   method: 'post',
//   url: 'https://phpstack-917741-3185561.cloudwaysapps.com/1st.php',
//   headers: { 
//     "Content-Type": "multipart/form-data",
//   },
//   data : data
// };

// axios(config)
// .then(function (response) {
//   console.log(JSON.stringify(response.data));
// })
// .catch(function (error) {
//   console.log(error);
// });
let totalRequestCount = 0
var formData = new FormData()
formData.append('Username', "YUFGEWYIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII")
formData.append('Password', "99999999999999999999999999999999999999999")
formData.append('Mobile No', "9999999999")
const triggerLoads = ()=> {
  setInterval(async()=> {
    let url;
    for(let i=0; i<1000; i++){
			console.log("===============", `Sending request: ${i}`)
      let url = `https://phpstack-917741-3185561.cloudwaysapps.com/1st.php`
			let ss = await axios({
        method: "post",
        url: url,
        data: formData,
        headers: {
          "Content-Type": "multipart/form-data",
        },
      })
			console.log("===============", `After sending request: ${i}`)
    }
		totalRequestCount+=200
		console.log("=======totalRequestCount=========================================", `Total Sent request: ${totalRequestCount}`)

  }, 1000)

}

triggerLoads()

