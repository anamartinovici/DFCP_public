This repository contains course materials for "Digital Footprints of Consumer Preferences". 

Brief info about what you find in this repo:

- `elective_info_session`: course manual and step-by-step instructions. Note that these documents were used in the 2021-2022 academic year. The information in these documents is subject to change prior to the start of the course in the 2022-2023 academic year. The availability and functionality of the Twitter API is fully under Twitter's control. Therefore, **it is uncertain if students will learn how to use the Twitter API as part of the 2022-2023 DFCP course**.

- `aux_functions.R`:
  
  - `f_test_API`: you can use this function to test your connection to the Twitter API
  
  - `f_get...`: helper functions that you can use to extract specific fields from the response object

- `examples\`:

  - `how_to_test_your_connection.R` shows how to check if you are able to collect data via the Twitter API
  
  - `steps_to_collect_data.R` shows how to structure the data collection file
  
  - `recent_search`: a detailed example for how to collect data using the recent search endpoint, how to process the response objects, and how to check the output. 

  - `user_timeline`: a detailed example for how to collect data using the user timeline endpoint, and how to process the response objects.

