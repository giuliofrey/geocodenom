*! version 1.0.0 16May2024

program define geocodenom
    // Check if the required arguments are provided
    syntax varlist(min=1 max=1), save(string) 
    
    // Extract the variable name containing addresses
    local address_var `1'
    
    // Create new variables for latitude and longitude
    gen double latitude = .
    gen double longitude = .
    
    // Loop over each observation
    qui {
        forvalues i = 1 / `=_N' {
            // Get the address for the current observation
            local address = `address_var'[`i']
            
            // URL encode the address
            local address_urlencoded = ustrregexra("`address'", " ", "+")
            
            // Construct the API URL
            local url = "https://nominatim.openstreetmap.org/search?q=`address_urlencoded'&format=json&limit=1"
            
            // Use curl to fetch the JSON response from the API
            tempfile response
            shell curl -s -o `response' "`url'"
            
            // Parse the JSON response to extract latitude and longitude
            import delimited using `response', delimiter(" ") clear
            if _N > 0 {
                jsonio json use `response'
                mata: st_numscalar("latitude", real("`json['[0]']['lat']'"))
                mata: st_numscalar("longitude", real("`json['[0]']['lon']'"))
                replace latitude = `=latitude' in `i'
                replace longitude = `=longitude' in `i'
            }
        }
    }
    
    // Save the dataset with geocoded data
    save "`save'", replace
end
